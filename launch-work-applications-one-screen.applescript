#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Launch Work Applicationssss
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖






set numberOfDisplays to 1
set displayNames to {}
set numberOfSpacesForEachDisplay to {5}
set applicationsForEachDisplay to {{{"GitKraken"}, {"Slack", "Microsoft Outlook", "Microsoft Teams"}, {"Google Chrome"}, {"Reminders", "Notion", "Spotify"}, {"Postman"}}}
set keyCodeMap to {18, 19, 20, 21, 23, 22, 26, 28, 25, 29}
set defaultSpaces to {2, 2}


do shell script "open -a 'Mission Control'"
repeat with i from 1 to numberOfDisplays
	set numberOfSpacesForCurrentDisplay to item i of numberOfSpacesForEachDisplay
	repeat with j from 1 to numberOfSpacesForCurrentDisplay
		if j is not 1 then
			tell application "System Events" to click (every button whose value of attribute "AXDescription" is "add desktop") of group 2 of group i of group 1 of process "Dock"
		end if
	end repeat
end repeat
delay 1
tell application "System Events" to key code 53 using {control down}
delay 1


set spacesOffset to 0
repeat with i from 1 to numberOfDisplays
	set currentWindowCountForDisplay to 1
	repeat with j from 1 to (item (i) of (numberOfSpacesForEachDisplay))
		
		tell application "System Events"
			key code (item (spacesOffset + 1) of keyCodeMap) using {control down}
		end tell
		delay 1
		set applicationsToOpenForCurrentWindow to item currentWindowCountForDisplay of (item i of applicationsForEachDisplay)
		
		repeat with k from 1 to count of applicationsToOpenForCurrentWindow
			set applicationName to (item k of applicationsToOpenForCurrentWindow)
			tell application applicationName to launch
			
		end repeat
		
		
		repeat with k from 1 to count of applicationsToOpenForCurrentWindow
			log "Waiting for window for app " & (item k of applicationsToOpenForCurrentWindow)
			tell application "System Events"
				set application_id to (get the id of my application (item k of applicationsToOpenForCurrentWindow))
				set process_id to id of (application processes where bundle identifier is application_id)
				log application_id
			end tell
			
			set limit to 25
			set theBool to false
			repeat until theBool
				tell application "System Events" to tell process id process_id
					try
						if button 1 of window 1 exists then
							set theBool to true
							delay 0.2
							set limit to limit + 1
						end if
					on error e number n
						if n is not -1728 then
							error e
						else
							log "No applications found for window " & currentWindowCountForDisplay & " of display " & i
						end if
					end try
				end tell
			end repeat
			
			
			
			tell application (item k of applicationsToOpenForCurrentWindow)
				activate
				delay 0.5 -- Add a delay to ensure the application is fully activated
			end tell
			
			if numberOfDisplays > 1 then
				tell application "System Events"
					tell process id process_id
						set frontmost to true
						delay 0.5
						tell menu bar 1
							tell menu bar item "Window"
								click
								delay 0.5 -- Add a delay to ensure the menu has fully appeared
								log "Move to " & (item i of displayNames)
								if exists menu item ("Move to " & (item i of displayNames)) of menu "Window" then
									click menu item ("Move to " & (item i of displayNames)) of menu "Window"
								else
									click
								end if
							end tell
						end tell
					end tell
				end tell
			end if
		end repeat
		
		
		set spacesOffset to spacesOffset + 1
		set currentWindowCountForDisplay to currentWindowCountForDisplay + 1
		delay 1
	end repeat
end repeat


set spacesOffset to 0
repeat with i from 1 to numberOfDisplays
	log spacesOffset
	log i
	log item (spacesOffset + (item i of defaultSpaces))
	tell application "System Events"
		key code (item (spacesOffset + (item i of defaultSpaces)) of keyCodeMap) using {control down}
	end tell
	set spacesOffset to spacesOffset + (item i of numberOfSpacesForEachDisplay)
end repeat
