# التعديلات | Changes

Snapshot: **2026-10-05**. المصدر الأساسي هو الملفات الحالية، لا نسخ backup قديمة.

## إعداد سطح المكتب

Niri يستخدم `us,ara` مع `Super+Space` وCompose على Right Alt وCaps كـ Ctrl. بقي mouse focus وscrolling columns واختصارات workspace/window المعتادة. `prefer-no-csd` وخيار Qt يطلبان إخفاء native decorations من التطبيقات الداعمة. قاعدة عامة تضبط opacity إلى 85% مع blur، واستثناء YouTube داخل Helium يجعله opaque؛ Waybar وSwayNC notification surface لهما استثناءات blur. قاعدة btop تطلب عرض 850px حتى لا يظهر خطأ terminal too small.

Waybar هو البار الحالي: كبسولات ووحدات hardware/tray، لغة الإدخال، network/battery menus. زر لوحة المفاتيح العربية يشغّل سكربت toggle. تُعرض الشبكات والمعلومات فقط من الجهاز الذي يشغّل النسخة؛ لا تُخزّن بيانات هذا الجهاز هنا.

الثيم يربط لونًا واحدًا بملفات Niri/Waybar/Kitty/Rofi وGTK/Qt والمحررات. Neovim يقرأ `omarchy-palette.json` بتبديل ذري، ويراقبه كل ثانية وعند FocusGained. الخلفيات وsaved state تبقى محلية. Kitty يستخدم Bash فعليًا وopacity 0.65 وcursor trail؛ تعليق fish القديم صُحح في النسخة العامة.

## فروق النسخة العامة عن الجهاز

- استبدال home paths بـ `@HOME@` حيث يلزم path حقيقي، أو `$HOME` داخل shell commands. Niri يستخدم `spawn-sh` لتمكين shell expansion.
- حذف AI status/account usage modules وبيانات التطبيقات، وعدم نسخ أدوات AI التنفيذية.
- عدم نقل الحزم التنفيذية أو font binaries أو مئات wallpapers والثيمات المحمّلة.
- تعطيل تحديثات LazyVim الخلفية؛ lockfile هو تعريف plugins لا سجل تحديثات.
- حذف Code settings/Chromium policy writes من theme script؛ يبقى تكامل desktop/editor colors.
- استبدال avatar الخاص بـ SDDM وإزالة username الافتراضي الثابت.
- battery menu يستعمل helper بصلاحية إدارية. `full` في helper يعني 95/100 بينما النسخة القديمة من القائمة كانت تكتب 0/100 مباشرة؛ `balanced` يعني 70/80.
- حماية scripts من بعض اعتماديات Fedora غير الموجودة، دون تثبيت برامج تلقائيًا.

هذه الفروق تخص النسخة العامة فقط. لم نطبّقها على جلسة الجهاز.

## التاريخ خارج snapshot

الجهاز انتقل سابقًا من GNOME/GDM إلى SDDM، وجُرّبت Hyprland/Mango/Noctalia. الملفات الحالية لا تحتوي جلسات Hyprland/Mango كاملة؛ لم نستعد configs المحذوفة من backups ولم ننشر سكربتات إزالة النظام القديمة. Noctalia hook الباقي محفوظ كإضافة legacy اختيارية، وليس البار الحالي. تفاصيل التجارب الشخصية تبقى في Obsidian.
