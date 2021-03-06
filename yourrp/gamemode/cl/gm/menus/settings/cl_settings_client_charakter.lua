--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

net.Receive( "getCharakterList", function()
  local ply = LocalPlayer()
  local _charTab = net.ReadTable()

  local cl_rpName = createVGUI( "DTextEntry", settingsWindow.site, 400, 50, 10, 40 )
  if _charTab.rpname != nil then
    cl_rpName:SetText( _charTab.rpname )
  end
  function cl_rpName:OnChange()
    net.Start( "change_rpname" )
      net.WriteString( cl_rpName:GetText() )
    net.SendToServer()
  end

end)

hook.Add( "open_client_character", "open_client_character", function()
  local ply = LocalPlayer()

  local w = settingsWindow.sitepanel:GetWide()
  local h = settingsWindow.sitepanel:GetTall()

  settingsWindow.site = createD( "DPanel", settingsWindow.sitepanel, w, h, 0, 0 )
  function settingsWindow.site:Paint( w, h )
    draw.SimpleTextOutlined( lang_string( "name" ) .. ":", "sef", ctr( 10 ), ctr( 45 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0 ) )
  end

  net.Start( "getCharakterList" )
  net.SendToServer()
end)
