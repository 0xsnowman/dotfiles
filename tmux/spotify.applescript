on escape_quotes(string_to_escape)
  set AppleScript's text item delimiters to the "\""
  set the item_list to every text item of string_to_escape
  set AppleScript's text item delimiters to the "\\\""
  set string_to_escape to the item_list as string
  set AppleScript's text item delimiters to ""
  return string_to_escape
end escape_quotes

tell application "System Events"
  set myList to (name of every process)
end tell

if myList contains "Spotify" then
  tell application "Spotify"
    set ctrack to my escape_quotes(current track's artist) & ": "
    set ctrack to ctrack & my escape_quotes(current track's name) & " "
    set ctrack to ctrack & "(" & my escape_quotes(current track's album) & ")"
  end tell
else
  set ctrack to "Spotify"
end if
