# Obsdn-QuickSNIPP
ahk script for Obsidian.md to make transclusions from text blocks, save web snippets and take quick notes

use AUTOHOTKEY UNICODE 

This script is a replacement for Obsdn-AutoSnipp.ahk with enhanced features

# DESCRIPTION

## WebSNIPP WebClipper

 `CTRL ALT C` copy selected HTML to the clipboard as markdown
 

`CTRL ALT X` save selected HTML as a md file, and get the transclusion link in obsidian format

 `CTRL F9` save current webpage as a md file via the fuckyeahmarkdown.com API, and get the transclusion link in obsidian format. It's slow and sends keyboard shortcuts, so it's not highly reliable... Tested on FF, Chrome,  Brave , Maxthon
 

  ## QuickSNIPP Scratchpad

`CAPS LOCK x2` display a scratchpad floating window to write quick notes. Save the notes as snippets and get the transclusion link. Hide the scratchpad with `ESC` or click on the `X` button. 


## AutoSNIPP Transcluder

 `CTRL SHIFT X` extract the selected text as a new file, get the transclusion link = INSTANCES or BLOCK REFERENCE

 `CTRL SHIFT C` extract the selected text as a file, then get the transclusion link = CLONING blocks.
 
 since the new block is a copy, it can be modified independently, without modyfing the original paragraph


# CONFIGURATION / INSTALLATION

this script requires [**AutoHotkey UNICODE**](https://www.autohotkey.com/) to be installed. 
It relies on the following libs :
* Winclip by Deo http://www.apathysoftworks.com/ahk/index.html with the UTF8 mod from https://www.autohotkey.com/boards/viewtopic.php?f=6&t=29314&start=20#topahk%20strput
* CreateFormData.ahk 	by tmplinshi + mod by SKAN https://www.autohotkey.com/boards/viewtopic.php?p=85687#p85687

the required ahk files are provided in \_includes. make sure to update the correct path in the CONFIG section.

**Before first use, edit the .ahk file with a text editor to change the default configuration**
search for 'CONFIG' and modify :
* the path to the `include` libs
* the location to save the snippets in your obisidan vault
* optionally, tweak the naming convention for the generated snippets
* optionally, modify the macro shortcuts

#### the script is free to share and modify. Please reshare/make a pull request if you improve it. 


# SCREENSHOTS

transcluder demo
![obsdn-autosnipp-demo.gif](https://github.com/cannibalox/Obsdn-Autosnipp/blob/master/obsdn-autosnipp-demo.gif)

![obsdn-quicksnipp-scratchpad.png](https://github.com/cannibalox/Obsdn-QuickSNIPP/blob/master/obsdn-quicksnipp-scratchpad.png)

![Obsidian-autosnipp.png](https://github.com/cannibalox/Obsdn-Autosnipp/blob/master/Obsidian-autosnipp.png)

![obsdn-autosnipp_firefox.png](https://github.com/cannibalox/Obsdn-Autosnipp/blob/master/obsdn-autosnipp_firefox.png)

# VIDEO DEMO

https://filedn.com/locqGc5NIUyfrWR1S0M3dRz/videos/obsdn-quicksnipp/obsdn-quicksnipp-demo.mp4

https://filedn.com/locqGc5NIUyfrWR1S0M3dRz/videos/obsdn-quicksnipp/obsdn-quicksnipp-scratchpad.mp4
