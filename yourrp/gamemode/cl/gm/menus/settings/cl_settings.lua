--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

include( "cl_settings_client_hud.lua" )
include( "cl_settings_client_charakter.lua" )

include( "cl_settings_server_general.lua" )
include( "cl_settings_server_roles.lua" )
include( "cl_settings_server_give.lua" )
include( "cl_settings_server_money.lua" )
include( "cl_settings_server_map.lua" )
include( "cl_settings_server_whitelist.lua" )
include( "cl_settings_server_restriction.lua" )

include( "cl_settings_yourrp_add_langu.lua")
include( "cl_settings_yourrp_contact.lua")
include( "cl_settings_yourrp_workshop.lua")

local _yrp_settings = {}
_yrp_settings.design = {}
_yrp_settings.design.mode = "dark"
_yrp_settings.materials = {}
_yrp_settings.materials.logo100 = Material( "vgui/yrp/logo100_beta.png" )
_yrp_settings.materials.dark = {}
_yrp_settings.materials.dark.close = Material( "vgui/yrp/dark_close.png" )
_yrp_settings.materials.dark.settings = Material( "vgui/yrp/dark_settings.png" )
_yrp_settings.materials.dark.burger = Material( "vgui/yrp/dark_burger.png" )

_yrp_settings.materials.light = {}
_yrp_settings.materials.light.close = Material( "vgui/yrp/light_close.png" )
_yrp_settings.materials.light.settings = Material( "vgui/yrp/light_settings.png" )
_yrp_settings.materials.light.burger = Material( "vgui/yrp/light_burger.png" )

function get_icon_burger_menu()
  return _yrp_settings.materials[_yrp_settings.design.mode].burger
end

function closeSettings()
  if settingsWindow != nil then
    settingsWindow:Close()
  end
end

function openSettings()
  openMenu()
  addMDColor( "dprimary", getMDPColor() )
  addMDColor( "dprimaryBG", colorBG( getMDPColor() ) )

  addMDColor( "dsecondary", getMDSColor() )
  addMDColor( "dsecondaryH", colorH( getMDSColor() ) )

  local ply = LocalPlayer()

  --Frame
  settingsWindow = createMDMenu( nil, ScrW(), ScrH(), 0, 0 )
  function settingsWindow:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, get_dbg_col() )
  end
  function settingsWindow:OnClose()
    closeMenu()
  end
  function settingsWindow:OnRemove()
    closeMenu()
  end

  --Sites
  settingsWindow:AddCategory( lang_string( "client" ) )
  settingsWindow:AddSite( "open_client_character", lang_string( "character" ), lang_string( "client" ), "icon16/user_edit.png" )
  settingsWindow:AddSite( "open_client_hud", lang_string( "hud" ), lang_string( "client" ), "icon16/photo.png" )
  settingsWindow:AddSite( "open_client_keybinds", lang_string( "keybindchanger" ), lang_string( "client" ), "icon16/keyboard.png" )

  if ply:IsAdmin() or ply:IsSuperAdmin() then
    local _server = lang_string( "server" ) .. " (" .. tostring( lang_string( "admin" ) ) .. ")"
    settingsWindow:AddCategory( _server )
    settingsWindow:AddSite( "open_server_general", lang_string( "general" ), _server, "icon16/server_database.png" )
    settingsWindow:AddSite( "open_server_roles", lang_string( "roles" ), _server, "icon16/group_gear.png" )
    settingsWindow:AddSite( "open_server_give", lang_string( "give" ), _server, "icon16/user_go.png" )
    settingsWindow:AddSite( "open_server_money", lang_string( "money" ), _server, "icon16/money.png" )
    settingsWindow:AddSite( "open_server_map", lang_string( "map" ), _server, "icon16/map.png" )
    settingsWindow:AddSite( "open_server_whitelist", lang_string( "whitelist" ), _server, "icon16/page_white_key.png" )
    settingsWindow:AddSite( "open_server_restrictions", lang_string( "restriction" ), _server, "icon16/group_go.png" )
  end

  settingsWindow:AddCategory( "yourrp" )
  settingsWindow:AddSite( "open_yourp_workshop", lang_string( "workshop" ), "yourrp", "icon16/layout_content.png" )
  settingsWindow:AddSite( "open_yourp_contact", lang_string( "contact" ), "yourrp", "icon16/user_comment.png" )
  settingsWindow:AddSite( "open_yourp_add_langu", "Add Language", "yourrp", "icon16/comment_add.png" )

  settingsWindow:AddCategory( lang_string( "settings" ) )
  settingsWindow:AddSite( "open_menu_settings", lang_string( "settings" ), lang_string( "settings" ), "vgui/yrp/dark_settings.png" )

  --StartSite
  settingsWindow.cursite = lang_string( "character" )
  settingsWindow:SwitchToSite( "open_client_character" )

  --Mainbar
  local mainBar = createD( "DPanel", settingsWindow, ScrW(), ctr( 100 ), 0, 0 )
  function mainBar:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, get_dp_col() )

    surface.SetDrawColor( 255, 255, 255, 255 )
    surface.SetMaterial( _yrp_settings.materials.logo100	)
    surface.DrawTexturedRect( ctr( 100 + 400 + 10 ), ctr( 10 ), ctr( 400*0.6 ), ctr( 130*0.6 ) )

    if !version_tested() then
  		testVersion()
  	end
  	local _singleplayer = ""
  	if game.SinglePlayer() then
  		_singleplayer = "Singleplayer"
  	end
  	draw.SimpleTextOutlined( _singleplayer .. " (" .. GAMEMODE.dedicated .. " Server) " .. GAMEMODE.Version, "HudBars", ctr( 820 ), ph/2, version_color(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

    --draw.SimpleTextOutlined( settingsWindow.cursite or "", "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end

  local liveSupport = createD( "DButton", settingsWindow, ctr( 300 ), ctr( 80 ), ScrW() - ctr( 1150 ), ctr( 10 ) )
  liveSupport:SetText( "" )
  function liveSupport:DoClick()
    gui.OpenURL( "https://discord.gg/CXXDCMJ" )
  end
  function liveSupport:Paint( pw, ph )
    paintMDBackground( self, pw, ph )
    draw.SimpleTextOutlined( "Live Support!", "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end

  local language = createD( "DPanel", settingsWindow, ctr( 650 ), ctr( 80 ), ScrW() - ctr( 840 ), ctr( 10 ) )
  function language:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, get_ds_col() )
    draw.SimpleTextOutlined( "Language: ", "HudBars", ctr( 250 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
  derma_change_language( language, ctr( 400 ), ctr( 80 ), ctr( 250 ), ctr( 0 ) )

  local settingsButton = createD( "DButton", mainBar, ctr( 80 ), ctr( 80 ), ScrW() - ctr( 180 ), ctr( 10 ) )
  settingsButton:SetText( "" )
  function settingsButton:Paint( pw, ph )
    paintMDBackground( self, pw, ph )

  	surface.SetDrawColor( 255, 255, 255, 255 )
  	surface.SetMaterial( _yrp_settings.materials[_yrp_settings.design.mode].settings	)
  	surface.DrawTexturedRect( ctr( 15 ), ctr( 15 ), ctr( 50 ), ctr( 50 ) )
  end

  hook.Add( "open_menu_settings", "open_menu_settings", function()
    local ply = LocalPlayer()

    local w = settingsWindow.sitepanel:GetWide()
    local h = settingsWindow.sitepanel:GetTall()

    settingsWindow.site = createD( "DPanel", settingsWindow.sitepanel, w, h, 0, 0 )
    function settingsWindow.site:Paint( pw, ph )
      draw.RoundedBox( 4, 0, 0, pw, ph, get_dbg_col() )
      draw.SimpleTextOutlined( lang_string( "color" ), "HudBars", ctr( 10 ), ctr( 200 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0 ) )
    end

    local switchMode = createMDSwitch( settingsWindow.site, ctr( 400 ), ctr( 80 ), ctr( 10 ), ctr( 10 ), "dark", "light", "cl_mode" )

    --primary
    colorP = {}
    colorP[1] = Color( 66, 66, 66, 255 )
    colorP[2] = Color( 21, 101, 192, 255 )
    colorP[3] = Color( 46, 125, 50, 255 )
    colorP[4] = Color( 239, 108, 0, 255 )
    colorP[5] = Color( 249, 168, 37, 255 )
    colorP[6] = Color( 78, 52, 46, 255 )

    local primarybg = createD( "DPanel", settingsWindow.site, ctr( 400 ), ctr( 200 ), ctr( 10 ), ctr( 200 ) )

    for k, v in pairs( colorP ) do
      addPColorField( primarybg, v, ctr( 10 + (k-1)*60 ), ctr( 10 ) )
    end

    --secondary
    colorS = {}
    colorS[1] = Color( 117, 117, 117, 255 )
    colorS[2] = Color( 30, 136, 229, 255 )
    colorS[3] = Color( 67, 160, 71, 255 )
    colorS[4] = Color( 251, 140, 0, 255 )
    colorS[5] = Color( 253, 216, 53, 255 )
    colorS[6] = Color( 109, 76, 65, 255 )

    local secondarybg = createD( "DPanel", settingsWindow.site, ctr( 400 ), ctr( 200 ), ctr( 500 ), ctr( 200 ) )

    for k, v in pairs( colorS ) do
      addSColorField( secondarybg, v, ctr( 10 + (k-1)*60 ), ctr( 10 ) )
    end
  end)

  function settingsButton:DoClick()
    settingsWindow:SwitchToSite( "open_menu_settings" )
  end

  local exitButton = createD( "DButton", mainBar, ctr( 80 ), ctr( 80 ), ScrW() - ctr( 80 + 10 ), ctr( 10 ) )
  exitButton:SetText( "" )
  function exitButton:Paint( pw, ph )
    paintMDBackground( self, pw, ph )

  	surface.SetDrawColor( 255, 255, 255, 255 )
  	surface.SetMaterial( _yrp_settings.materials[_yrp_settings.design.mode].close	)
  	surface.DrawTexturedRect( ctr( 15 ), ctr( 15 ), ctr( 50 ), ctr( 50 ) )
  end
  function exitButton:DoClick()
    settingsWindow:Remove()
    settingsWindow = nil
  end

  local burgerMenu = createD( "DButton", mainBar, ctr( 480 ), ctr( 80 ), ctr( 10 ), ctr( 10 ) )
  burgerMenu:SetText( "" )
  function burgerMenu:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 100 ) )
    if self:IsHovered() then
      draw.RoundedBox( 0, 0, 0, ph, ph, get_dsbg_col() )
    else
      draw.RoundedBox( 0, 0, 0, ph, ph, get_ds_col() )
    end

  	surface.SetDrawColor( 255, 255, 255, 255 )
  	surface.SetMaterial( _yrp_settings.materials[_yrp_settings.design.mode].burger	)
  	surface.DrawTexturedRect( ctr( 15 ), ctr( 15 ), ctr( 50 ), ctr( 50 ) )

    draw.SimpleTextOutlined( string.upper( lang_string( "menu" ) ), "HudBars", ctr( 90 ), ctr( 40 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
  end
  function burgerMenu:DoClick()
    settingsWindow:openMenu()
  end

  settingsWindow:MakePopup()
end
