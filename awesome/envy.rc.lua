require('awful')           -- std awesome lib
require('awful.autofocus')
require('awful.rules')
require('beautiful')       -- themes
require('naughty')         -- notification

-- { ERROR HANDLING
--
if awesome.startup_errors then
  naughty.notify(
    {
      preset = naughty.config.presets.critical,
      title  = 'HORROR during startup!',
      text   = awesome.startup_errors
    }
  )
end

-- Handle runtime errors (after startup)
do
  local in_error = false
  awesome.add_signal( 'debug:error', function (err)
    if in_error then
      return
    end
    in_error = true
    naughty.notify(
      {
        preset = naughty.config.presets.critical,
        title  = 'HORROR!',
        text   = err
      }
    )
    in_error = false
  end)
end
-- }

-- { VARIABLE DEFINITION
--
home    = os.getenv( 'HOME' )
confdir = home .. '/.config/awesome'
editor  = 'vim'
modkey  = 'Mod4'
term    = 'urxvt'

lower_volume = 'amixer -c 0 set Master 2dB-'
raise_volume = 'amixer -c 0 set Master 2dB+'

beautiful.init( confdir .. '/theme.lua' )

layouts = {
  awful.layout.suit.floating,
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.spiral,
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier
}
-- }

-- { MENU
--
envy_awesome_menu = {
  { 'firefox', 'firefox' },
  { 'restart', awesome.restart },
  { 'quit',    awesome.quit    },
}

envy_main_menu = awful.menu( {
  items = {
    { 'awesome',  envy_awesome_menu },
    { 'terminal', term              },
  }
} )
-- }

-- { WIDGETS 
--
envy_clock     = awful.widget.textclock( { align = 'right' } )
envy_launcher  = awful.widget.launcher( 
  { 
    image = image( beautiful.awesome_icon ),
    menu  = envy_main_menu
  } 
)
envy_layoutbox = { }
envy_promptbox = { }
envy_taglist   = { }
envy_tasklist  = { }
envy_tray      = widget( { type = 'systray' } )
envy_wibox     = { }

envy_taglist.buttons = awful.util.table.join(
  awful.button( {         }, 1, awful.tag.viewonly ),
  awful.button( { modkey, }, 1, awful.client.movetotag ),
  awful.button( {         }, 3, awful.tag.viewtoggle ),
  awful.button( { modkey, }, 3, awful.client.toggletag )
)

envy_tasklist.buttons = { }
-- }

-- { TAGS
--
tag_labels = {
  { 1, 2, 3, 4, 5, 6, 7, 'music', 'web' },
  { 1, 2, 'xen', 4, 5, 6, 7, 8, 'skype' }
}

tags = { }
-- }

-- { MAIL NOTIFICATIONS
--
mailbox       = widget( { type = 'textbox', align = 'right' } )
mailbox.text  = ' ~ Mail 0 ~ '
mailbox_timer = timer( { timeout = 15 } )
mailbox_timer:add_signal(
  'timeout',
  function ()
    local mfile  = io.popen( 'python -c "import mailbox\nprint len(mailbox.mbox(\'$HOME/Mail/inbox\'))"', 'r' )
    mailbox.text = string.format( ' ~ Mail %d ~ ', mfile:read('*a') ) --' ~ Mail ' .. mfile:read('*a') .. ' ~ '
  end
)
mailbox_timer:start()
-- }

-- { WIBOX
-- for each screen
for s = 1, screen.count() do
  tags[s] = awful.tag( tag_labels[s], s, layouts[1] )

  envy_promptbox[s] = awful.widget.prompt( 
    { layout = awful.widget.layout.horizontal.leftright } 
  )

  envy_layoutbox[s] = awful.widget.layoutbox( s )
  --
  envy_layoutbox[s]:buttons(awful.util.table.join(
                         awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                         awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                         awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                         awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
  --

  envy_taglist[s] = awful.widget.taglist( 
    s, 
    awful.widget.taglist.label.all, 
    envy_taglist.buttons 
  )

  envy_tasklist[s] = awful.widget.tasklist( 
    function (c)
      return awful.widget.tasklist.label.currenttags( c, s )
    end,
    envy_tasklist.buttons
  )

  envy_wibox[s] = awful.wibox( { position = 'bottom', screen = s } )
  envy_wibox[s].widgets = {
    -- left-to-right
    {
      envy_promptbox[s],
      envy_launcher,
      mailbox,
      envy_taglist[s],
      envy_layoutbox[s],
      envy_clock,
      layout = awful.widget.layout.horizontal.leftright
    },
    -- right-to-left
    s == 1 and envy_tray or nil,
    envy_tasklist[s],
    layout = awful.widget.layout.horizontal.rightleft
  }
end
-- }

-- { KEY BINDINGS
--
globalkeys = awful.util.table.join(

  -- Fn+F8
  awful.key({ }, 'XF86AudioLowerVolume', function () 
                                           awful.util.spawn( lower_volume )             end ),
  -- Fn+F9
  awful.key({ }, 'XF86AudioRaiseVolume', function () 
                                           awful.util.spawn( raise_volume )             end ),


  awful.key({ modkey,           }, 'Escape', awful.tag.history.restore                      ),
  awful.key({ modkey,           }, 'Return', function () awful.util.spawn( term )       end ),
  awful.key({ modkey,           }, 'space', function () awful.layout.inc( layouts, 1 )  end ),
  awful.key({ modkey, 'Shift'   }, 'space', function () awful.layout.inc( layouts, -1 ) end ),
  awful.key({ modkey,           }, 'F12', function () 
                                            awful.util.spawn( beautiful.screenlock_cmd )
                                                                                        end ), 
  -- Q -> '
  awful.key({ modkey, 'Control' }, '\'', awesome.quit                                       ),

  -- R -> P
  awful.key({ modkey,           }, 'p', function () 
                                          awful.prompt.run( 
                                            { prompt = '$ ' },
                                            envy_promptbox[mouse.screen].widget,
                                            awful.util.spawn,
                                            awful.completion.shell )                    end ),
  awful.key({ modkey, 'Control' }, 'p', awesome.restart                                     ),

  -- I -> C
  awful.key({ modkey,           }, 'c', function () awful.tag.incmwfact( -0.05 )        end ),
  awful.key({ modkey, 'Shift'   }, 'c', function () awful.tag.incmaster( -1 )           end ),
  awful.key({ modkey, 'Control' }, 'c', function () awful.tag.incncol( -1 )             end ),

  -- O -> R
  awful.key({ modkey,           }, 'r', function () awful.tag.incmwfact( 0.05 )         end ),
  awful.key({ modkey, 'Shift'   }, 'r', function () awful.tag.incmaster( 1 )            end ),
  awful.key({ modkey, 'Control' }, 'r', function () awful.tag.incncol( 1 )              end ),

  -- H -> D
  awful.key({ modkey,           }, 'd', awful.tag.viewprev                                  ),

  -- J -> H
  awful.key({ modkey,           }, 'h', function () 
                                          awful.client.focus.byidx( -1 )      
                                          if client.focus then client.focus:raise() end end ),
  awful.key({ modkey, 'Shift'   }, 'h', function () awful.client.swap.byidx( -1 )       end ),
  awful.key({ modkey, 'Control' }, 'h', function () awful.screen.focus_relative( -1 )   end ),

  -- K -> T
  awful.key({ modkey,           }, 't', function () 
                                          awful.client.focus.byidx( 1 )      
                                          if client.focus then client.focus:raise() end end ),
  awful.key({ modkey, 'Shift'   }, 't', function () awful.client.swap.byidx( 1 )        end ),
  awful.key({ modkey, 'Control' }, 't', function () awful.screen.focus_relative( 1 )    end ),

  -- L -> N
  awful.key({ modkey,           }, 'n', awful.tag.viewnext                                  ),

  -- X -> Q
  awful.key({ modkey,           }, 'q', function () 
                                          awful.prompt.run( 
                                            { prompt = 'lua> ' },
                                            envy_promptbox[mouse.screen].widget,
                                            awful.util.eval,
                                            nil,
                                            awful.util.getdir('cache') .. '/history_eval' )
                                                                                        end ),

  -- N -> B
  awful.key({ modkey, 'Control' }, 'b', awful.client.restore                                ) 
)

-- {{ 1..9 KEYS
keynumber = 0
for s = 1, screen.count() do
  keynumber = math.min( 9, math.max( #tags[s], keynumber ) )
  print( keynumber )
end

for i = 1, keynumber do
  globalkeys = awful.util.table.join( globalkeys,
    
    awful.key( { modkey,                    }, '#' .. i + 9, 
               function ()                                                                 
                 local screen = mouse.screen
                 if tags[screen][i] then
                   awful.tag.viewonly( tags[screen][i] )
                 end
               end ),

    awful.key( { modkey,          'Control' }, '#' .. i + 9, 
               function ()                                                                 
                 local screen = mouse.screen
                 if tags[screen][i] then
                   awful.tag.viewtoggle( tags[screen][i] )
                 end
               end ),

    awful.key( { modkey, 'Shift',           }, '#' .. i + 9, 
               function ()                                                                 
                 if client.focus and tags[client.focus.screen][i] then
                   awful.client.movetotag( tags[client.focus.screen][i] )
                 end                                                                        
               end ),

    awful.key( { modkey, 'Shift', 'Control' }, '#' .. i + 9, 
               function ()                                                                 
                 if client.focus and tags[client.focus.screen][i] then
                   awful.client.toggletag( tags[client.focus.screen][i] )
                 end                                                                        
               end )
  )
end
-- }}

clientkeys = awful.util.table.join(
  awful.key({ modkey, 'Control' }, 'Return', function (c) 
                                               c:swap( awful.client.getmaster() )
                                                                                        end ),
  awful.key({ modkey, 'Control' }, 'space', awful.client.floating.toggle                    ),

  -- R -> P
  awful.key({ modkey, 'Shift'   }, 'p', function (c) c:redraw()                         end ),

  -- T -> Y
  awful.key({ modkey,           }, 'y', function (c) c.ontop = not c.ontop              end ),

  -- F -> U
  awful.key({ modkey,           }, 'u', function (c) c.fullscreen = not c.fullscreen    end ),

  -- H -> D
  awful.key({ modkey, 'Shift'   }, 'd', function (c) 
                                          awful.client.movetoscreen( c, c.screen - 1 )
                                                                                        end ),
  -- L -> N
  awful.key({ modkey, 'Shift'   }, 'n', function (c) 
                                          awful.client.movetoscreen( c, c.screen + 1 )
                                                                                        end ),

  -- C -> J
  awful.key({ modkey, 'Control' }, 'j', function (c) c:kill()                           end ),

  -- N -> B
  awful.key({ modkey, 'Shift'   }, 'b', function (c) c.minimized = true                 end ),

  -- M
  awful.key({ modkey,           }, 'm', function (c) 
                                          c.maximized_horizontal = not c.maximized_horizontal
                                          c.maximized_vertical   = not c.maximized_vertical
                                                                                        end ) 
)

clientbuttons = awful.util.table.join(
  awful.button( {        }, 1, function (c) client.focus = c; c:raise() end ),
  awful.button( { modkey }, 1, awful.mouse.client.move                      ),
  awful.button( { modkey }, 3, awful.mouse.client.resize                    )
)

-- set keys
root.keys( globalkeys )
-- }

-- { RULES 
--
awful.rules.rules = { 
  {
    rule       = { },
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus        = true,
      keys         = clientkeys,
      buttons      = clientbuttons,
    },
  },
  {
    rule       = { class = 'mplayer' },
    properties = { floating = true },
  },
}
-- }

-- { SIGNALS 
--
client.add_signal( 'manage',
  function (c, startup)

  awful.titlebar.add( c, { modkey = modkey } )

    c:add_signal( 'mouse::enter',
      function (c)
        if awful.client.focus.filter( c ) then
          client.focus = c
        end
      end )

  end )

client.add_signal( 'focus', 
  function (c) 
    c.border_color = beautiful.border_focus 
  end )

client.add_signal( 'unfocus', 
  function (c) 
    c.border_color = beautiful.border_normal 
  end )
-- }
