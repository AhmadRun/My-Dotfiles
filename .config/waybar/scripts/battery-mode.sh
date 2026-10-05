#!/bin/bash
# Short label for the current power profile + charge limit, for waybar.
p=$(busctl --system get-property net.hadess.PowerProfiles /net/hadess/PowerProfiles net.hadess.PowerProfiles ActiveProfile | cut -d'"' -f2)
e=$(</sys/class/power_supply/BAT0/charge_control_end_threshold)
case $p in performance) i="󰓅";; power-saver) i="󰌪";; *) i="󰾅";; esac
icon() { printf "<span font_family='JetBrainsMono Nerd Font Mono' font='14px'>%s</span>" "$1"; }
[[ $e -lt 100 ]] && l="$(icon 󰂃) ${e}%" || l=""
printf '{"text":"%s %s","tooltip":"Profile: %s\\nCharge limit: %s%%","class":"%s"}\n' "$(icon "$i")" "$l" "$p" "$e" "$p"
