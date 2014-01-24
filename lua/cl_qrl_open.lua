if CLIENT then
net.Receive( "url_list", function()
	local my_table = net.ReadTable()
	
	LocalPlayer():PrintMessage( HUD_PRINTCONSOLE, "\n----------------------")
	for k,v in pairs(my_table) do 
			if !(string.StartWith( v, "http")) and (table.FindNext( my_table, v) != (table.GetFirstValue( my_table ) ) ) then
				LocalPlayer():PrintMessage( HUD_PRINTCONSOLE, "\n"..my_table[k].." - "..table.FindNext(my_table, my_table[k]).."\n" )
			end
		end
	LocalPlayer():PrintMessage( HUD_PRINTCONSOLE, "----------------------\n")
	chat.AddText( 
		Color(0,173,238), "!",
		Color(255,255,255), "qrl",
		Color(0,173,238), " - ",
		Color(255,255,255), "List of URLs printed to console",
		Color(0,173,238), "." 
		)
end)


end