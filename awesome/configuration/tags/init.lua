-- Standard awesome library
local awful = require("awful")
local gears = require("gears")
local lain = require("lain")

-- local icons = require('theme.icons')
local apps = require('configuration.apps')
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.floating,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  --awful.layout.suit.fair,
  --awful.layout.suit.fair.horizontal,
  awful.layout.suit.spiral,
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  --awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier,
  --awful.layout.suit.corner.nw,
  --awful.layout.suit.corner.ne,
  --awful.layout.suit.corner.sw,
  --awful.layout.suit.corner.se,
  lain.layout.cascade,
  --lain.layout.cascade.tile,
  lain.layout.centerwork,
  --lain.layout.centerwork.horizontal,
  --lain.layout.termfair,
  --lain.layout.termfair.center
}

local function setMagnifierMasterWidthFactor(screen)
  local tag = screen.selected_tag
  if tag.layout == awful.layout.suit.magnifier then
      tag.master_width_factor = 0.9 -- Adjust this value as needed
  else
      tag.master_width_factor = awful.layout.gettagprevtilefactor(tag) or 0.5
  end
end

local function onLayoutChanged(screen)
  setMagnifierMasterWidthFactor(screen)
end



-- Configure Tag Properties
awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
end)
-- }}}

