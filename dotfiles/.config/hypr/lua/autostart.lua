-- lua/autostart.lua

hl.on("hyprland.start", function ()

  hl.exec_cmd(networkApplet)

  hl.exec_cmd(notificationDa)

  hl.exec_cmd(wallpaperDaemon)

  hl.exec_cmd("caelestia shell -d")
  -- portal/polkit
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  -- clipboard
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")

  -- daemon dbus apps gtk/qt
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

end)