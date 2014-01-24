if SERVER then
	AddCSLuaFile( "cl_qrl_open.lua" )
	include( "qrl_open.lua" )

	if !file.Exists( "qrl_storage" , "DATA" ) then 
		file.CreateDir( "qrl_storage" )
	end
end

if CLIENT then
	include( "cl_qrl_open.lua" )

end