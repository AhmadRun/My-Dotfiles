# المتطلبات | Dependencies

هذه قائمة أدوات الإعداد، وليست export للتطبيقات المثبتة أو إصداراتها أو تحديثاتها. ثبّت ما تحتاجه من مصادر المشروع/Fedora الموثوقة؛ المستودع لا يضيف package repositories ولا يثبّت software.

| Area | Tools / packages |
|---|---|
| Desktop | Niri build supporting configured blur/background-effect, Waybar, Rofi with Wayland support |
| Wallpaper/theme | awww + awww-daemon, Matugen, Python 3.11+, Git, curl, ImageMagick (`magick`), libnotify (`notify-send`) |
| Terminal | Kitty supporting cursor_trail; Bash; optional Fish + Starship; Fastfetch, btop |
| Audio/media | PipeWire/WirePlumber (`wpctl`), playerctl, optional Cava |
| Brightness/network/power | brightnessctl, NetworkManager (`nmcli`), power-profiles-daemon (`busctl` access) |
| Notifications/lock/clipboard | SwayNotificationCenter, swaylock, wl-clipboard, cliphist |
| GUI appearance | adw-gtk3, qt5ct, qt6ct, Adwaita icons, Figtree, JetBrains Mono Nerd Font, optional Readex Pro |
| Editors/files | Neovim supporting LazyVim, Helix, Yazi, optional Nautilus; Git for plugin downloads |
| Section launcher | Python PyGObject (`gi`/Gio); `rofi-sections` remains optional |
| Arabic keyboard | Custom wvkbd build; instructions in OPTIONAL.md |
| Validation | Python 3.11+, Bash, optional Gitleaks, Fish, Niri, Rofi, Neovim |

عدّل `thermal-zone: 5` في Waybar بحسب جهازك. إعداد البطارية يفترض `BAT0` ودعم `charge_control_*_threshold`؛ لا يعمل على كل الأجهزة. ضبط `font-family` يحتاج fonts منفصلة لم تُنشر هنا.

الـ GTK/Qt environment والتغييرات على apps قد تحتاج إعادة فتح التطبيق أو تسجيل خروج ودخول. بدء Waybar/SwayNC/clipboard watchers مضبوط من Niri؛ لا تفعّل services مكررة لنفس البرنامج.

اختصار لوحة المفاتيح العربية يحتاج تثبيت binary المحلي وتفعيل `arabic-keyboard.service` بنفسك. `cliphist-wipe.service` متاح اختياريًا لكنه لا يتفعّل لمجرد نسخ ملفه.
