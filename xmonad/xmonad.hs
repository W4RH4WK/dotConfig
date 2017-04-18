import Control.Applicative
import XMonad
import XMonad.Actions.SinkAll
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.Minimize
import XMonad.Layout.BinarySpacePartition (emptyBSP)
import XMonad.Layout.Minimize
import XMonad.Layout.Spacing
import XMonad.Actions.Navigation2D
import XMonad.Util.EZConfig (additionalKeysP, removeKeysP)

import qualified XMonad.StackSet as W

main = xmonad
     $ ewmh
     $ nav
     $ def {
        focusedBorderColor = "#00aaff",
        normalBorderColor = "#36393e",

        focusFollowsMouse = False,
        clickJustFocuses = False,

        workspaces = map show [1..6 :: Int],

        modMask = mod4Mask,

        handleEventHook =  handleEventHook def
                       <+> fullscreenEventHook
                       <+> minimizeEventHook,

        manageHook = manageDocks,

        layoutHook = avoidStruts
                   $ minimize
                   $ spacingWithEdge 6
                   $ Tall 1 0.03 0.62 ||| emptyBSP ||| Full
     }

    `removeKeysP` ["M-w", "M-e", "M-r", "M-p", "M-S-p", "M-S-c", "M-S-/"]

    `additionalKeysP` [
        ("M-[", sendMessage Shrink),
        ("M-]", sendMessage Expand),

        ("M-S-t", sinkAll),

        ("M-x", withFocused minimizeWindow),
        ("M-S-x", kill),
        ("M-S-<Delete>", spawn "xkill"),

        ("M-<Backspace>", spawn "dm-tool lock"),

        ("M-a", screenWorkspace 0 >>= flip whenJust (windows . W.view)),
        ("M-s", screenWorkspace 1 >>= flip whenJust (windows . W.view)),
        ("M-d", screenWorkspace 2 >>= flip whenJust (windows . W.view)),

        ("M-S-a", screenWorkspace 0 >>= flip whenJust (windows . W.shift)),
        ("M-S-s", screenWorkspace 1 >>= flip whenJust (windows . W.shift)),
        ("M-S-d", screenWorkspace 2 >>= flip whenJust (windows . W.shift)),

        ("M-r", spawn "rofi -modi run -show run"),
        ("M-`", spawn "rofi -modi window -show window"),

        ("M-e", spawn "x-terminal-emulator"),
        ("M-f", spawn "nemo"),
        ("M-c", spawn "gnome-calculator"),

        ("<XF86Tools>", spawn "gnome-system-monitor"),

        ("<Print>", spawn "xfce4-screenshooter -f"),
        ("M-<Print>", spawn "xfce4-screenshooter -w"),
        ("S-<Print>", spawn "xfce4-screenshooter -r")
    ]

nav = navigation2DP config ("k", "h", "j", "l") modifiers False
  where
    modifiers = [("M-", windowGo), ("M-S-", windowSwap)]
    config = def {
        defaultTiledNavigation = centerNavigation
    }
