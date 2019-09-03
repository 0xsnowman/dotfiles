import json
import logging
import os
import socket
import struct
from enum import Enum
from socket import AF_UNIX, socket
from time import time
from uuid import uuid4

import pynvim  # pylint: disable=E0401

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

if os.environ.get('DISCORD_DEBUG'):
    fh = logging.FileHandler('debug.log')
    formatter = logging.Formatter('%(message)s')
    fh.setFormatter(formatter)
    logger.addHandler(fh)

class Opcodes(Enum):
    HANDSHAKE = 0
    FRAME = 1
    CLOSE = 2

class RPCClient:
    def __init__(self):
        self.socket = None
        self.connected = False

    def connect(self):
        try:
            self.socket = socket(AF_UNIX)
            self.socket.connect(os.path.join(os.environ['TMPDIR'], 'discord-ipc-0'))
            self.handshake()
            self.connected = True

            self.set_activity({
                'details': 'Idling',
                'state': 'Idling',

                'assets': {
                    'large_image': 'neovim-small',
                    'large_text': 'Idling',
                }
            })
        except OSError:
            pass

    def handshake(self):
        self.send({
            'client_id': os.environ['DISCORD_CLIENT_ID'],
            'v': 1,
        }, Opcodes.HANDSHAKE)

        op, data = self.recv(8)

        if op == Opcodes.FRAME.value and data['cmd'] == 'DISPATCH' and data['evt'] == 'READY':
            return
        else:
            if op == Opcodes.CLOSE.value:
                self.close()

            raise RuntimeError(data)

    def close(self):
        self.send({}, Opcodes.CLOSE)
        self.socket.close()

    def send(self, data, opcode: Opcodes):
        opcode_value = opcode.value
        payload = json.dumps(data).encode('utf-8')
        header = struct.pack('<II', opcode_value, len(payload))

        logger.debug(f'SENDING op: {opcode_value}, payload: {payload}')

        try:
            self.socket.sendall(header)
            self.socket.sendall(payload)
        except:
            self.connect()
            self.send(data, opcode)

    def recv(self, size):
        op, length = struct.unpack('<II', self.get_from_buffer(size))
        payload = json.loads(self.get_from_buffer(length).decode('utf-8'))

        logger.debug(f'RECEIVING op: {op}, payload: {payload}')

        return op, payload

    def get_from_buffer(self, size):
        content = b''

        while size:
            chunk = self.socket.recv(size)
            content += chunk
            size -= len(chunk)

        return content

    def set_activity(self, activity):
        activity['timestamps'] = { 'start': int(time()) }

        self.send({
            'cmd': 'SET_ACTIVITY',
            'args': { 'pid': os.getpid(), 'activity': activity },
            'nonce': str(uuid4())
        }, Opcodes.FRAME)

FT_OVERRIDES = {
    'javascriptreact': 'react',
}

@pynvim.plugin
class DiscordPlugin:
    def __init__(self, nvim):
        self.client = RPCClient()
        self.nvim = nvim

    def update(self):
        if not self.client.connected: return

        current_buffer = self.nvim.current.buffer
        filetype = current_buffer.options['filetype']
        ft_info = FT_OVERRIDES.get(filetype, filetype)

        self.client.set_activity({
            'details': f'Editing {os.path.basename(current_buffer.name)}',

            'assets': {
                'large_image': ft_info or 'neovim-logo',
                'large_text': f'Editing a {ft_info.upper()} file',
                'small_image': 'neovim-small',
                'small_text': 'Neovim'
            }
        })

    @pynvim.autocmd('VimEnter')
    def on_vim_enter(self):
        self.client.connect()

    @pynvim.autocmd('VimLeave')
    def on_vim_leave(self):
        self.client.connected: self.client.socket.close()

    @pynvim.autocmd('BufEnter')
    def on_buf_enter(self, _eval):
        self.update()

    @pynvim.autocmd('BufRead')
    def on_buf_read(self, _eval):
        self.update()

    @pynvim.autocmd('BufNewFile')
    def on_buf_new_file(self, _eval):
        self.update()
