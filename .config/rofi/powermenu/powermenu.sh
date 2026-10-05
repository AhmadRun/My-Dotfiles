#!/usr/bin/env bash
# Power menu in the main rofi theme, opening under the bar's power button.
THEME='window { location: north east; anchor: north east; x-offset: -8px; y-offset: 28px; width: 320px; }
listview { lines: 5; fixed-height: false; }
element-icon { enabled: false; }
inputbar { enabled: false; }'
up=$(uptime -p | sed 's/^up //')
menu() { rofi -dmenu -i -no-custom -mesg "$1" -theme-str "$THEME"; }

choice=$(printf '%s\n' "󰌾  Lock" "󰤄  Suspend" "󰍃  Log out" "󰜉  Reboot" "󰐥  Shut down" | menu "Uptime: $up")
[[ -z $choice ]] && exit
confirm() { [[ $(printf '%s\n' "  Yes" "  No" | menu "${choice#*  }?") == *Yes ]]; }
case $choice in
  *Lock)     swaylock ;;
  *Suspend)  confirm && systemctl suspend ;;
  *"Log out") confirm && niri msg action quit -s ;;
  *Reboot)   confirm && systemctl reboot ;;
  *"Shut down") confirm && systemctl poweroff ;;
esac
