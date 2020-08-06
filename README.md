# Obsdn-QuickSNIPP
ahk script for Obsidian.md to make transclusions from text blocks, save web snippets and take quick notes

use AUTOHOTKEY UNICODE 

This script is a replacement for Obsdn-AutoSnipp.ahk

## WebSNIPP WebClipper

 `CTRL ALT C` copy selected HTML to the clipboard as markdown
 

`CTRL ALT X` save selected HTML as a md file, and get the transclusion link in obsidian format

 `CTRL F9` save current webpage as a md file via the fuckyeahmarkdown.com API, and get the transclusion link in obsidian format. It's slow and sends keyboard shortcuts, so it's not highly reliable... Tested on FF, Chrome,  Brave , Maxthon
 
 ----
  ## QuickSNIPP Scratchpad

`CAPS LOCK x2` display a scratchpad floating window to write quick notes. Save the notes as snippets and get the transclusion link.

----

## AutoSNIPP Transcluder

 `CTRL SHIFT X` extract the selected text as a new file, get the transclusion link = INSTANCES or BLOCK REFERENCE

 `CTRL SHIFT C` extract the selected text as a file, then get the transclusion link = CLONING blocks.
 
 since the new block is a copy, it can be modified independently, without modyfing the original paragraph

----

