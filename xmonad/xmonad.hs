import Control.Applicative
import Control.Monad (when)
import Data.Monoid
import XMonad
import XMonad.Actions.GroupNavigation
import XMonad.Actions.Navigation2D
import XMonad.Actions.SinkAll
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.Minimize
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Minimize
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
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
                       <+> minimizeEventHook
                       <+> minimizeShiftFocus,

        manageHook =  manageDocks
                  <+> (className =? "Xfce4-notifyd" --> doIgnore),

        logHook = historyHook,

        layoutHook = avoidStruts
                   $ minimize
                   $ mkToggle1 NBFULL
                   $ spacingWithEdge 6
                   $ smartBorders
                   $ Tall 1 0.03 0.62 ||| emptyBSP ||| Full
     }

    `removeKeysP` ["M-w", "M-e", "M-r", "M-p", "M-S-p", "M-S-c", "M-S-/"]

    `additionalKeysP` [
        ("M-/", sendMessage Rotate),
        ("M-[", sendMessage Shrink >> sendMessage (ExpandTowards L)),
        ("M-]", sendMessage Expand >> sendMessage (ExpandTowards R)),

        ("M-\\", sendMessage $ Toggle NBFULL),

        ("M-S-t", sinkAll),

        ("M-x", withFocused minimizeWindow >> windows W.focusDown),
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

-- * Custom Hooks

minimizeShiftFocus :: Event -> X All
minimizeShiftFocus (ClientMessageEvent {ev_message_type = mt,
                                        ev_data = dt}) = do
    a_cs <- getAtom "WM_CHANGE_STATE"
    when (mt == a_cs) $ do
        let message = fromIntegral $ head dt
        when (message == iconicState) $ focusPrev
    return $ All True
minimizeShiftFocus _ = return $ All True

-- * Utils

focusPrev :: X ()
focusPrev = nextMatch History (return True)
