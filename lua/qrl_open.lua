if SERVER then 
util.AddNetworkString( "url_list" )

	storage = {}
	

function urlCheck( ply, text, public )
	local allowed_groups = { "superadmin" }
	local errorMsg = 
		[[
			chat.AddText( Color(0,173,238), "!",
			Color(255,255,255), "qrl",
			Color(0,173,238), " - ",
			Color(255,255,255), "You don't have permission to use that command",
			Color(0,173,238), "." )
		]]
	
	if storage and storage[text] then
		ply:SendLua([[gui.OpenURL("]] ..storage[text]..[[")]] )
	end
	
	if (string.StartWith( text, "!qrl" ) ) and !( text == "!qrlview" ) then
		for k,v in pairs(allowed_groups) do
			if ply:IsUserGroup( v ) then
				urlMaker( ply, text )
				ply.allowed = true
				break
			else
				ply.allowed = false
			end
		end
		if !ply.allowed then
			ply:SendLua(errorMsg)
		end
	end	
	
	if (text == "!qrlview") then
		updateTable()
		if !file.Exists( "qrl_storage/custom_urls.txt", "DATA" ) then
			ply:SendLua(
					[[
						chat.AddText( 
						Color(0,173,238), "!",
						Color(255,255,255),"qrl",
						Color(0,173,238)," - ",
						Color(255,255,255),"Currently no URLs",
						Color(0,173,238), "." )
					]] )
		else
			local temp_table = string.Explode( " ", file.Read( "qrl_storage/custom_urls.txt" , "DATA" ) )
			
			net.Start("url_list")
			net.WriteTable( temp_table )
			net.Send( ply )
		end
	end
end
	

function urlMaker( ply, text, public )
	if text == "!qrlclear" then
		urlClear( ply )
	end
	
	if (string.StartWith(text, "!qrlremove")) then
		urlRemove( ply, text )
	end
	
	
	if (string.StartWith(text, "!qrl")) and !(text == "!qrlclear") and !(string.StartWith(text, "!qrlremove")) then
		local expansion = string.Explode( " ", text)
			updateTable()
			if expansion[2] and expansion[3] then
				if (string.StartWith(expansion[3], "http://") ) then
				if storage[expansion[2]] then
					storage[expansion[2]] = nil
					storage[expansion[2]] = expansion[3]
					updateList()
					ply:SendLua(
						[[
							chat.AddText( 
							Color(0,173,238), "!",
							Color(255,255,255),"qrl",
							Color(0,173,238)," - ",
							Color(255,255,255),"Replacing URL for ",
							Color(0,173,238),"]] ..expansion[2].. [[",
							Color(255,255,255), "." )
						]] )
				else
					storage[expansion[2]] = expansion[3]
					ply:SendLua(
						[[
							chat.AddText( 
							Color(0,173,238), "!",
							Color(255,255,255),"qrl",
							Color(0,173,238)," - ",
							Color(255,255,255),"Pairing URL with keyword ",
							Color(0,173,238),"]] ..expansion[2].. [[",
							Color(255,255,255), "." )
						]] )
					if !file.Exists( "qrl_storage/custom_urls.txt", "DATA") then					
						file.Write( "qrl_storage/custom_urls.txt", expansion[2].." "..expansion[3].." ")
					else
						file.Append( "qrl_storage/custom_urls.txt", expansion[2].." "..expansion[3].." ")
					end
				end
				else
				ply:SendLua(
					[[
						chat.AddText( 
						Color(0,173,238), "!",
						Color(255,255,255),"qrl",
						Color(0,173,238)," - ",
						Color(255,255,255),"The URL must start with 'http://'",
						Color(0,173,238), "." )
					]] )
				end
			else
			ply:SendLua(
				[[
					chat.AddText( 
					Color(0,173,238), "!",
					Color(255,255,255),"qrl",
					Color(0,173,238)," - ",
					Color(255,255,255),"Format is '!qrl <keyword> <URL>'",
					Color(0,173,238), "." )
				]] )
			end
	end
		
end
hook.Add( "PlayerSay", "qrlHook", urlCheck )

function urlClear( ply )
	file.Delete( "qrl_storage/custom_urls.txt")
		storage = nil
	ply:SendLua(
		[[
			chat.AddText( 
			Color(0,173,238), "!",
			Color(255,255,255),"qrl",
			Color(0,173,238)," - ",
			Color(255,255,255),"All URLs cleared",
			Color(0,173,238), "." )
		]] )
					
end

function updateTable()
	storage = {}
	
	if file.Exists( "qrl_storage/custom_urls.txt", "DATA" ) then
		local temp_table = string.Explode( " ", file.Read( "qrl_storage/custom_urls.txt" , "DATA" ) )
		for k,v in pairs(temp_table) do
			if !(string.StartWith( v, "http")) and (table.FindNext( temp_table, v) != (table.GetFirstValue( temp_table ) ) ) then
				storage[v] = table.FindNext( temp_table, v )
			end
		end
	end
end

function updateList()
	file.Delete( "qrl_storage/custom_urls.txt" )
	
	for k,v in pairs(storage) do
		if v != "" then
			if !file.Exists( "qrl_storage/custom_urls.txt", "DATA") then					
				file.Write( "qrl_storage/custom_urls.txt", k.." "..v.." ")
			else
				file.Append( "qrl_storage/custom_urls.txt", k.." "..v.." ")
			end
		end
	end
end

function urlRemove( ply, text )
	local temp_string = string.Explode( " ", text )
	local save_storage = storage
		storage = {}
		
	ply:SendLua(
		[[
			chat.AddText( 
			Color(0,173,238), "!",
			Color(255,255,255),"qrl",
			Color(0,173,238)," - ",
			Color(255,255,255),"Purging keyword ",
			Color(0,173,238),"]] ..temp_string[2].. [[",
			Color(255,255,255), "." )
		]] )
	if file.Exists( "qrl_storage/custom_urls.txt", "DATA" ) then
		local temp_table = string.Explode( " ", file.Read( "qrl_storage/custom_urls.txt" , "DATA" ) )
		for k,v in pairs(temp_table) do
			if !(string.StartWith( v, "http")) and (table.FindNext( temp_table, v) != (table.GetFirstValue( temp_table ) ) ) and ( v != temp_string[2] and v != save_storage[temp_string[2]] )  then
				storage[v] = table.FindNext( temp_table, v )
			end
		end
		save_storage = nil
		updateList()
	end

end
hook.Add( "Initialize", "qrl_first", updateTable )
end