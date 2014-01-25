qrl_opener
==========
Quick-URL Opener
Made by: Picklebutt
	
To install:
1. Drop qrl_opener folder into your server's 'addons' folder.
2. Set up allowed_groups in qrl_opener/lua/qrl_open.lua, the format is: allowed_groups = { "superadmin", "owner", "admin" }
		
Commands:
!qrl <keyword> <URL> : this creates a keyword and url pairing or overwrites an existing keyword with a new URL. The URL will open if the keyword is typed.
example: !qrl google http://google.com - if I type 'google' in chat, www.google.com will open.
		
!qrlclear : this erases all keywords and URLs.
		
!qrlremove <keyword> : this erases the pairing associated with this keyword.
example: !qrlremove google - now typing 'google' in chat no longer opens any URLs.
			
!qrlview : this command is available to everyone and prints a list of all current keywords and URLs in the console.
	
To Remove:
1. Remove qrl_opener in your server's 'addons' folder.
2. Remove qrl_storage in your server's 'data' folder.