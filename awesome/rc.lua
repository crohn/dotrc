local awful = require( 'awful' )
local beautiful = require( 'beautiful' )
local wibox = require( 'wibox' )

require( 'awful.autofocus' )

beautiful.init( '/usr/share/awesome/themes/default/theme.lua' )

local A_ = 'Mod1'
local M_ = 'Mod4'
local C_ = 'Control'
local S_ = 'Shift'

local term = 'xterm'

local layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.fair
}
local tags = { }
tags[1] = awful.tag({ 1, 2, 3 }, s, layouts[1] )

_wibox = { }
_promptbox = { }
_layoutbox = { }
_tasklist = { }
_taglist = { }

for s = 1, screen.count() do
  _promptbox[s] = awful.widget.prompt()
  _layoutbox[s] = awful.widget.layoutbox( s )
  _taglist[s] = awful.widget.taglist( s, awful.widget.taglist.filter.all, nil )
  _tasklist[s] = awful.widget.tasklist( s, awful.widget.tasklist.filter.currenttags, nil )
  _wibox[s] = awful.wibox({ position = 'top', screen = s })

  local left_layout = wibox.layout.fixed.horizontal()
  left_layout:add( _taglist[s] )
  left_layout:add( _promptbox[s] )

  local right_layout = wibox.layout.fixed.horizontal()
  if s == 1 then right_layout:add( wibox.widget.systray() ) end
  right_layout:add( _layoutbox[s] )

  local layout = wibox.layout.align.horizontal()
  layout:set_left( left_layout )
  layout:set_middle( _tasklist[s] )
  layout:set_right( right_layout )
  
  _wibox[s]:set_widget( layout )
end

globalkeys = awful.util.table.join(
  awful.key({ M_, S_, }, 'q', awesome.quit ),
  awful.key({ M_,     }, 'r', function () _promptbox[mouse.screen]:run() end ),
  awful.key({ M_, S_, }, 'r', awesome.restart ),
  awful.key({ M_,     }, 'Return', function () awful.util.spawn( term ) end ),
  awful.key({ M_,     }, 'space', function () awful.layout.inc( layouts, 1 ) end ),

  awful.key({ M_,     }, 'h', 
    function ()
      awful.client.focus.bydirection( 'left' )
      if client.focus then
        client.focus:raise()
      end
    end),

  awful.key({ M_,     }, 's',
    function ()
      awful.client.focus.bydirection( 'right' )
      if client.focus then
        client.focus:raise()
      end
    end),

  awful.key({ M_,     }, 't', 
    function ()
      awful.client.focus.bydirection( 'down' )
      if client.focus then
        client.focus:raise()
      end
    end),

  awful.key({ M_,     }, 'n', 
    function ()
      awful.client.focus.bydirection( 'up' )
      if client.focus then
        client.focus:raise()
      end
    end)
)

for i = 1, 9 do
  globalkeys = awful.util.table.join( globalkeys,
    awful.key({ M_, }, '#' .. i + 9,
    function ()
      local s = mouse.screen
      local tag = awful.tag.gettags( s )[i]
      if tag then
        awful.tag.viewonly( tag )
      end
    end)
  )
end

root.keys( globalkeys )

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
