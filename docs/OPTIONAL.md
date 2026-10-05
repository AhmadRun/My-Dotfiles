# إضافات اختيارية | Optional components

لا يكتب `scripts/install.py` في `/etc` أو `/usr`، ولا يفعّل service. انسخ أجزاء النظام فقط بعد مراجعتها وحفظ نسخة من الملفات الموجودة. لا تعِد تشغيل SDDM من داخل جلسة فيها عمل مفتوح.

## SDDM: Cruze Noir

`optional/sddm/root/` يحفظ QML الحالي وخيار تفعيل الثيم مع avatar عام من SVG، دون الصورة الأصلية/reference. بعد حفظ نسخ الملفات السابقة:

```bash
sudo install -d /usr/share/sddm/themes/cruze-noir /etc/sddm.conf.d
sudo install -m 644 optional/sddm/root/usr/share/sddm/themes/cruze-noir/* /usr/share/sddm/themes/cruze-noir/
sudo install -m 644 optional/sddm/root/etc/sddm.conf.d/90-cruze-noir.conf /etc/sddm.conf.d/
sudo restorecon -RF /usr/share/sddm/themes/cruze-noir /etc/sddm.conf.d/90-cruze-noir.conf
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/cruze-noir
```

الساعة Canvas والواجهة تتكيّف مع الشاشة؛ authentication يحصل عبر SDDM وقت الاستخدام فقط. Test mode لا يثبت نجاح الدخول الحقيقي. للتراجع استعد override والثيم السابقين من backup، أو أزل override إذا لم يكن موجودًا قبل التثبيت، ثم ارجع لشاشة الدخول بعد حفظ العمل. لم ننسخ معلومات SDDM state عن آخر مستخدم/جلسة.

## Battery helper

المصدر تحت `optional/battery/root/`. يقبل `status`, `full`, `balanced`, `restore` فقط، ويقرأ BAT0 ويتحقق من القيم ويرجع عنها عند فشل الكتابة. `full=95/100` و`balanced=70/80`. حالته في `/var/lib/cruze-charge-mode/profile` تتولد لاحقًا ولا تُنشر.

```bash
# بعد backup ومراجعة المصدر، على جهاز يدعم هذه الملفات:
sudo install -m 755 optional/battery/root/usr/local/libexec/cruze-charge-mode /usr/local/libexec/cruze-charge-mode
sudo install -m 644 optional/battery/root/etc/systemd/system/cruze-charge-mode.service /etc/systemd/system/
sudo systemctl daemon-reload
pkexec /usr/local/libexec/cruze-charge-mode status
# التشغيل والإعداد الفعلي اختياريان:
# pkexec /usr/local/libexec/cruze-charge-mode balanced
# sudo systemctl enable cruze-charge-mode.service
```

تحتاج القائمة Polkit authentication agent لتقديم مطالبة `pkexec`. لا يوجد Polkit bypass أو rule يجعل sysfs writable للجميع. إذا لم يكن helper مثبتًا تبقى power profiles مستقلة ويظهر تنبيه عند اختيار charge limit. للتراجع عطّل service إذا فعّلتها، واستعد ملفاتها والـ helper السابقين؛ تغيير الملفات وحده لا يعيد limits، فاضبط القيم المناسبة لجهازك صراحة قبل إزالة helper.

## Arabic wvkbd layout

نشرنا headers التي تخص التعديل فقط، دون binary. upstream pinned commit:
`6b41504a0cb58fd1163fa44692398fbd61f8905f`.

```bash
git clone https://github.com/jjsullivan5196/wvkbd.git /tmp/wvkbd-build
cd /tmp/wvkbd-build
git checkout 6b41504a0cb58fd1163fa44692398fbd61f8905f
# انسخ config.arabicpc.h + keymap.arabicpc.h + layout.arabicpc.h من optional/arabic-keyboard هنا
make LAYOUT=arabicpc wvkbd-arabicpc
install -Dm755 wvkbd-arabicpc "$HOME/.local/bin/wvkbd-arabicpc"
systemctl --user daemon-reload
systemctl --user enable --now arabic-keyboard.service
```

Build requirements: C compiler/make/pkg-config، wayland-devel، wayland-protocols-devel، libxkbcommon-devel، pango-devel، وwayland-scanner. الخدمة تبدأ keyboard مخفية، وtoggle يرسل signal لإظهارها وإخفائها. للتراجع عطّل الخدمة واستعد الملف التنفيذي السابق إن وجد. المصدر/الترخيص الأصليان باقِيان في upstream وLICENSE المرفقة.

## Legacy Noctalia hook

`python3 scripts/install.py --only noctalia` يعرض الملفات، و`--apply` ينسخها. يحتاج Noctalia الذي يدعم أوامر msg/hooks المذكورة وPython Pillow. يحسب متوسط سطوع الخلفية ويختار light/dark عند threshold=0.55. **Noctalia ليست الواجهة الحالية** ولا يشغّل هذا المستودع Waybar وNoctalia معًا تلقائيًا. اربط hook بنفسك إذا رجعت لاستخدامها؛ source موجود للمعرفة والاستعادة الاختيارية.
