# التحقق | Validation

تم اختبار النسخة المعدّة للنشر في **2026-10-05** على Fedora 44 وجلسة Niri. SDDM كان active وقت التجميع. كل الاختبارات التي تكتب إعدادات الاستعادة استخدمت home مؤقتًا؛ لم نثبت هذه النسخة فوق إعدادات الجهاز الحالية.

## نجح

- Gitleaks **v8.30.1** من release الرسمي، مع تطابق checksum للـ archive: directory scan لم يجد secrets، دون exclusions/secret allowlist مخصصة.
- Python publication checker: allowed configuration areas, exact file hashes, text-only payload, known credential patterns, JSON/TOML/Python/Bash syntax.
- Niri `validate --config` على config المنشورة مباشرة، ثم على النسخة التي تحولت مساراتها داخل home اختباري.
- Rofi `-dump-theme` للـ config والـ launcher والـ wallpaper theme؛ لا interactive picker أثناء هذا الفحص.
- Fish `-n` على ملفات config المضمّنة.
- Neovim headless مع `-u NONE`: parsing للـ Lua وتحميل desktop palette إلى highlights، دون تحميل plugins أو تشغيل LazyVim init.
- Theme writer في home اختباري مع تعطيل جميع subprocess commands/signals/downloads: خروج متناسق للألوان وكتابة palette الخاصة بـ Neovim.
- Installer: dry run لا يكتب configs، apply يحفظ original files/symlink leaves، لا يمس الملفات غير المختارة، لا يثبت Noctalia افتراضيًا.
- Rollback يستعيد الملفات والـ symlinks السابقة، ويحافظ على الملفات غير التابعة له؛ يرفض restore إذا عُدّلت ملفات بعد installation.
- Installer يرفض target يحتوي symlink parent لمنع الكتابة خارج home المقصودة.
- Headers العربية بُنيت مع upstream pinned source إلى `wvkbd-arabicpc` في workspace معزول؛ executable الناتج ليس ضمن المستودع.

## حدود التحقق

لم نجرّب full-login restoration على مستخدم/جهاز جديد، أو authentication حقيقي عبر نسخة SDDM العامة، أو تغيير charge thresholds من النسخة المنشورة. ملف SDDM الحالي مصدره الثيم المثبت، لكن استبدال avatar اختُبر بالمصدر فقط. Noctalia hook legacy لم يُشغّل، ولم نثبت dependencies أو نجرب كل menu تفاعليًا. فحص Lua/palette لا يثبت تكامل كل LazyVim plugin.

Secret scanners لا تضمن اكتشاف كل معلومة خاصة؛ الملف الجديد يحتاج مراجعة حتى لو نجح الفحص. التحقق يخص هذه snapshot، لا أي تغيير لاحق.
