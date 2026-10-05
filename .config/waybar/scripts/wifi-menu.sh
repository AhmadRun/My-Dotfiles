#!/bin/bash
# Wi-Fi dropdown that opens under the bar's Wi-Fi icon (top-right), using nmcli.
# Uses the main rofi theme (~/.config/rofi/config.rasi); only placement changes here.
THEME='window { location: north east; anchor: north east; x-offset: -60px; y-offset: 28px; width: 320px; }
listview { lines: 8; fixed-height: false; }
element-icon { enabled: false; }
entry { placeholder: "Search networks"; }'
menu() { rofi -dmenu -i -no-custom -p "$1" -theme-str "$THEME" "${@:2}"; }

state=$(nmcli -t -f WIFI g)
if [[ $state != enabled ]]; then
    c=$(printf '󰤨  Turn Wi-Fi on\n' | menu "󰤭 Wi-Fi off")
    [[ -n $c ]] && nmcli radio wifi on
    exit
fi

notify-send -t 1500 "Wi-Fi" "Scanning…" 2>/dev/null
nmcli dev wifi rescan 2>/dev/null
current=$(nmcli -t -f ACTIVE,SSID dev wifi | awk -F: '$1=="yes"{print $2; exit}')

list=$(nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list | awk -F: -v cur="$current" '
  $1!="" && !seen[$1]++ {
    s=$2; icon = s>75 ? "󰤨" : s>50 ? "󰤥" : s>25 ? "󰤢" : "󰤟"
    lock = ($3=="" || $3=="--") ? " " : "󰌾"
    mark = ($1==cur) ? "  ✓" : ""
    printf "%s  %s %s%s\n", icon, lock, $1, mark
  }')

choice=$(printf '%s\n󰤭  Turn Wi-Fi off\n' "$list" | menu "󰤨 ${current:-Not connected}")
[[ -z $choice ]] && exit
if [[ $choice == *"Turn Wi-Fi off"* ]]; then nmcli radio wifi off; exit; fi

ssid=$(sed -E 's/^\S+\s+\S+\s//; s/  ✓$//' <<<"$choice")
[[ $ssid == "$current" ]] && exit

if nmcli -t -f NAME con show | grep -Fxq "$ssid"; then
    nmcli con up id "$ssid" >/dev/null 2>&1 && notify-send "Wi-Fi" "Connected to $ssid" || notify-send "Wi-Fi" "Could not connect to $ssid"
    exit
fi
if [[ $choice == *"󰌾"* ]]; then
    pass=$(rofi -dmenu -password -p "󰌾 $ssid" -theme-str "$THEME listview { lines: 0; } entry { placeholder: \"Password\"; }" </dev/null)
    [[ -z $pass ]] && exit
    nmcli dev wifi connect "$ssid" password "$pass" >/dev/null 2>&1
else
    nmcli dev wifi connect "$ssid" >/dev/null 2>&1
fi && notify-send "Wi-Fi" "Connected to $ssid" || notify-send "Wi-Fi" "Could not connect to $ssid"
