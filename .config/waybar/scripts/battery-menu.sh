#!/bin/bash
# Battery menu: power profile and charge limit.
BAT=/sys/class/power_supply/BAT0
prof=$(busctl --system get-property net.hadess.PowerProfiles /net/hadess/PowerProfiles net.hadess.PowerProfiles ActiveProfile | cut -d'"' -f2)
end=$(cat "$BAT/charge_control_end_threshold" 2>/dev/null || true)
mark() { [[ $1 == "$2" ]] && echo " ●" || echo ""; }
# Two columns: charging on the left, power profile on the right. The headings
# live outside the list so they can never be selected; the third row of the
# left column is an invisible filler (row 2, styled via -a).
opts="󰂄  Full Charge (100%)$(mark "$end" 100)
󰂃  Protect (70–80%)$(mark "$end" 80)
 \0nonselectable\x1ftrue
󰓅  Performance$(mark "$prof" performance)
󰾅  Balanced$(mark "$prof" balanced)
󰌪  Power Saver$(mark "$prof" power-saver)"
theme='window {width: 520px;}
mainbox {children: [inputbar, box-heads, listview];}
box-heads {orientation: horizontal; expand: false; children: [textbox-chg, textbox-pwr];}
textbox-chg {
  content: "CHARGING";
  font: "Figtree Bold 9";
  expand: true; text-color: @fgp-color; padding: 0 8px;
}
textbox-pwr {
  content: "POWER PROFILE";
  font: "Figtree Bold 9";
  expand: true; text-color: @fgp-color; padding: 0 8px;
}
listview {columns: 2; lines: 3; flow: vertical; fixed-columns: true;}
element alternate.normal {background-color: transparent;}
element normal.active, element alternate.active, element selected.active {background-color: transparent; text-color: transparent; border: 0;}
entry {placeholder: "";} element-icon {enabled: false;}'
choice=$(echo -e "$opts" | rofi -dmenu -i -a 2 -p "Battery $(cat $BAT/capacity)%" -no-custom -theme-str "$theme")
setp() { busctl --system set-property net.hadess.PowerProfiles /net/hadess/PowerProfiles net.hadess.PowerProfiles ActiveProfile s "$1"; }
setc() {
  local mode=$1
  if [[ ! -x /usr/local/libexec/cruze-charge-mode ]]; then
    notify-send "Battery" "Optional charge helper not installed; see docs/OPTIONAL.md"
    return 1
  fi
  pkexec /usr/local/libexec/cruze-charge-mode "$mode"
}

case "$choice" in
  *Performance*) setp performance ;;
  *Balanced*)    setp balanced ;;
  *"Power Saver"*) setp power-saver ;;
  *Full*)    setc full ;;
  *Protect*) setc balanced ;;
  *) exit ;;
esac
pkill -RTMIN+11 -x waybar
