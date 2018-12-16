if SERVER then

FREELOGS.Kills = {}
FREELOGS.Teams = {}
FREELOGS.Connect = {}

local function PlayerDeath( victim, inflictor, attacker )

			local Timestamp = os.time()
			local TimeString = os.date( "%d/%m/%Y - %H:%M:%S" , Timestamp )

			if victim:IsPlayer() and attacker:IsPlayer() and attacker != victim then
				FREELOGS.Kills[table.Count(FREELOGS.Kills) + 1] =  TimeString .. " - " .. tostring(victim:Name()).. "[" .. victim:SteamID().. "]" .. " was killed by " .. tostring(attacker:Name()) .. "[" .. attacker:SteamID().. "]" .. " using " .. tostring(inflictor:GetClass())
			elseif attacker == victim then
				FREELOGS.Kills[table.Count(FREELOGS.Kills) + 1] =  TimeString .. " - " .. tostring(victim:Name()) .. " suicide "
			else
				FREELOGS.Kills[table.Count(FREELOGS.Kills) + 1] =  TimeString .. " - " .. tostring(victim:Name()) .. " was killed by " .. tostring(attacker:GetClass()) .." using ".. tostring(inflictor:GetClass())
			end

			util.AddNetworkString( "FREELOGS.Kills" )
			net.Start( "FREELOGS.Kills" , true)
			net.WriteTable( table.Reverse( FREELOGS.Kills) )
			net.Broadcast()

end

local function OnPlayerChangedTeam( ply, oldTeam, newTeam )

			local Timestamp = os.time()
			local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )

			FREELOGS.Teams[table.Count(FREELOGS.Teams) + 1] =  TimeString .. " - " .. ply:Name() .. " Change team from " .. team.GetName( oldTeam )  .." to ".. team.GetName( newTeam )

			util.AddNetworkString( "FREELOGS.Teams" )
			net.Start( "FREELOGS.Teams" , true)
			net.WriteTable( table.Reverse( FREELOGS.Teams) )
			net.Broadcast()
end

local function PlayerConnect( name, ip )
			
			local Timestamp = os.time()
			local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )

			FREELOGS.Connect[table.Count(FREELOGS.Connect) + 1] =  TimeString .. " - " .. name .. " has joined the game. "
			util.AddNetworkString( "FREELOGS.Connect" )
			net.Start( "FREELOGS.Connect" , true)
			net.WriteTable( table.Reverse( FREELOGS.Connect) )
			net.Broadcast()
end

local function Disconnected( ply )
			
			local Timestamp = os.time()
			local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )

			FREELOGS.Connect[table.Count(FREELOGS.Connect) + 1] =  TimeString .. " - " .. ply:Name() .. " has left the server. "
			util.AddNetworkString( "FREELOGS.Connect" )
			net.Start( "FREELOGS.Connect" , true)
			net.WriteTable( table.Reverse( FREELOGS.Connect) )
			net.Broadcast()
end

net.Receive( "FREELOGS.Kills", function( len, ply )
		  
	end )

net.Receive( "FREELOGS.Kills", function( len, ply )
		  FREELOGS.Kills =  net.ReadTable()
		 PrintTable(FREELOGS.Kills)
	end )

net.Receive( "FREELOGS.Kills", function( len, ply )
		  FREELOGS.Kills =  net.ReadTable()
		 PrintTable(FREELOGS.Kills)
	end )

util.AddNetworkString( "Menus" )

hook.Add("PlayerDeath","Freelogs",PlayerDeath)

hook.Add("OnPlayerChangedTeam","Freelogs",OnPlayerChangedTeam)

hook.Add("PlayerConnect","Freelogs",PlayerConnect)

end


if CLIENT then

	Menus = { "Kills", "Degas", "Chat", "Propkill", "Props" , "Connection" , "Team" }

	if !FREELOGS.Kills then 
		FREELOGS.Kills = {}
	end

	net.Receive( "FREELOGS.Kills", function( len, ply )
		  FREELOGS.Kills =  net.ReadTable()
		 PrintTable(FREELOGS.Kills)
	end )

	net.Receive( "FREELOGS.Teams", function( len, ply )
		  FREELOGS.Teams =  net.ReadTable()
		 PrintTable(FREELOGS.Teams)
	end )

	local function Freelogs( table )

	Logs = vgui.Create( "DFrame" )
	Logs:SetSize( ScrW()/2 , ScrH()/2 )
	Logs:Center()
	Logs:MakePopup()
	Logs:SetTitle( "" )
	Logs:ShowCloseButton( false )
	Logs.Paint = function (s , w , h)
	    draw.RoundedBox(0 ,0 ,0 ,w + 120 ,h + 120 ,Color( 0 , 0 , 0 , 200))
	end

	local DScrollPanel = vgui.Create( "DScrollPanel", Logs )
	DScrollPanel:SetSize( ScrW()/6, ScrW()/3.7 )

		for k, v in pairs( Menus ) do
			local DButton = DScrollPanel:Add( "DButton" )
			DButton:SetIcon( "https://image.flaticon.com/icons/png/512/235/235251.png" )
			DButton:SetText( v )
			DButton:SetTextColor( Color( 200 , 200 , 200, 255))
			DButton:SetSize( ScrW()/20 , ScrH()/20 )
			DButton:Dock( TOP )
			DButton:DockMargin( 0, 0, 0, 2 )
			DButton.Paint = function (s , w , h)
		    draw.RoundedBox(0 ,0 ,0 ,w + 120 ,h + 120 , Color( 0 , 0 , 0 , 255 ) )
			end

			function DButton:DoClick()
				util.NetworkStringToID( "Menus" )
				net.Start( DButton:GetText() , true)
				net.WriteString(DButton:GetText())
				net.SendToServer()

			end
		end


	local DScrollPanelRight = vgui.Create( "DScrollPanel", Logs )
	DScrollPanelRight:SetSize( ScrW()/3, ScrW()/3.7 )
	DScrollPanelRight:SetPos( ScrW()/6, 0 )

		for k,v in pairs( table ) do
			local DButton = DScrollPanelRight:Add( "DButton" )
			DButton:SetIcon( "https://image.flaticon.com/icons/png/512/235/235251.png" )
			DButton:SetText( v )
			DButton:SetContentAlignment( 4 )
			DButton:SetTextColor( Color( 200 , 200 , 200, 255))
			DButton:SetSize( ScrW()/20 , ScrH()/50 )
			DButton:Dock( TOP )
			DButton:DockMargin( 0, 0, 0, 2 )
			DButton.Paint = function (s , w , h)
		    	draw.RoundedBox(0 ,0 ,0 ,w + 120 ,h + 120 , Color( 0 , 0 , 0 , 255 ) )
			end

			function DButton:DoClick()
				SetClipboardText( self:GetText() )
			end
		end

	local DermaButton = vgui.Create( "DButton", Logs )
	DermaButton:SetText( "Close" )	
	DermaButton:SetTextColor(Color(0,0,0,255))				
	DermaButton:SetPos( 0, ScrH()/2.070 )					
	DermaButton:SetSize( ScrW()/2, ScrW()/100 )					
	DermaButton.DoClick = function()				
	Logs:Close()			
	end

	DermaButton.Paint = function (s , w , h)
	    draw.RoundedBox(0 ,0 ,0 ,w + 120 ,h + 120 ,Color( 180, 10 , 10 , 225 ))
	end

end
	Freelogs( FREELOGS.Kills )

end