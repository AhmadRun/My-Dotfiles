# My Dotfiles

إعداداتي اليومية لبيئة **Fedora + Niri + Waybar**، مجمّعة من ملفات الجهاز الفعلية بعد مراجعة ما يصلح للنشر. أحافظ هنا على شكل سطح المكتب، الاختصارات العربية/الإنجليزية، والثيم المتناسق بين الطرفية والمحررات.

A curated, privacy-reviewed configuration snapshot. This is a desktop setup, not a home-directory backup or an application/account export.

## الموجود | Included

| Component | التعديلات |
|---|---|
| Niri | Arabic/English input, mouse focus, shortcuts, rounded desktop workflow, window opacity/blur rules, btop window width |
| Waybar | Workspaces, clock, audio, brightness, network, battery, hardware drawer, Arabic keyboard toggle |
| Rofi | Launcher, category picker, power menu, wallpaper/theme menus |
| Kitty + Bash/Fish + Starship | Cursor trail, transparency, fonts, copy/zoom shortcuts, prompt |
| Theme scripts | Omarchy palette picker + Matugen wallpaper colors; Niri/Waybar/Kitty/Rofi/GTK/Qt/Helix/btop/SwayNC/swaylock/Fastfetch/Neovim |
| Neovim | LazyVim Starter with live desktop palette integration; plugin lockfile, no plugin caches or update history |
| Helix + Yazi | Editor appearance/keymaps and smart-enter plugin |
| Optional | Custom Arabic wvkbd layout, Cruze Noir SDDM theme with generic avatar, battery helper, legacy Noctalia hook |

## الخصوصية | Privacy

لا يحتوي المستودع على browser profiles أو credentials أو محادثات AI أو API keys أو cookies أو clipboard history أو SSIDs محفوظة أو بيانات تطبيقات أو صور شخصية. لا توجد قائمة بجميع التطبيقات المثبتة أو سجلات/ملفات تحديثاتها. أسماء أدوات سطح المكتب تظهر فقط حيث تحتاجها الإعدادات.

أزيلت وحدات AI quota/account usage من نسخة Waybar العامة. لا نجمع `.config` بالكامل. التفاصيل والفحص في [SECURITY.md](SECURITY.md).

## الاستعادة | Restore

راجع [dependencies](docs/DEPENDENCIES.md) أولًا. النسخ لا يثبّت حزمًا ولا يبدأ services ولا يغيّر ملفات `/etc`.

```bash
git clone https://github.com/AhmadRun/My-Dotfiles.git
cd My-Dotfiles
python3 scripts/check.py
python3 scripts/install.py                 # preview only
python3 scripts/install.py --only kitty --only rofi --only bin
python3 scripts/install.py --apply           # selected user configuration + backup
```

`--only` قابل للتكرار؛ عند عدم تحديده تُنسخ إعدادات المستخدم الأساسية كلها. عند اختيار أجزاء، اختر dependencies معها: Niri/Waybar/Rofi تحتاج `bin`، وtheme picker يحتاج `themes`. الـ hooks القديمة لـ Noctalia تُنسخ فقط عند طلب `--only noctalia`، ولا تُفعّل تلقائيًا.

`@HOME@` يتحول أثناء الاستعادة إلى مسار المستخدم الجديد. لا تستخدم `cp -r` لكل المستودع لأن بعض الإعدادات تحتاج هذا التحويل. صلاحيات تشغيل السكربتات تُضبط من `docs/executable-paths.json` عند الاستعادة؛ ملفات الرفع عبر GitHub Web تُحفظ كـ text عادية. البرنامج يرفض symlink parents، ويحفظ الملفات الموجودة داخل backup خاص بالمستخدم، ولا يحمّل برامج من الإنترنت.

```bash
# استخدم مسار Backup الذي يظهر بعد النسخ
python3 scripts/install.py --restore "$HOME/.local/state/my-dotfiles/backups/<backup-id>"
python3 scripts/install.py --restore "$HOME/.local/state/my-dotfiles/backups/<backup-id>" --apply
```

التراجع يرفض حذف ملف تغيّر بعد الاستعادة؛ عندها راجع الفرق يدويًا. لا يحذف ملفات أخرى داخل مجلدات إعداداتك. ملفات backup قد تحتوي إعداداتك السابقة الخاصة؛ تبقى محلية ولا تُرفع.

## الاستخدام | Workflow

| Shortcut | Action |
|---|---|
| `Super+T` | Kitty |
| `Super+D` | Rofi launcher |
| `Super+Ctrl+Space` | Theme picker |
| `Super+Shift+W` | Wallpaper picker |
| `Super+Space` | English/Arabic layout |
| `Super+Alt+K` | Arabic on-screen keyboard |
| `Super+Ctrl+B` | Battery/power profile menu |
| `Super+N` | Notifications |
| `Super+Ctrl+F` | Files |
| `Super+Alt+L` | Screen lock |

ضع خلفياتك بنفسك في `~/Pictures/Wallpaper-Collection/Wallpapers`. الصور والثيمات المحمّلة ليست داخل Git. اختيار ثيم من catalogue يقوم بتحميله من مستودعه العام؛ راجع المصدر والترخيص قبل استخدامه. `omarchy-theme --previews` اختياري ويحمل صور preview. تشغيل Neovim لأول مرة قد يحمّل plugins عبر LazyVim؛ هذه خطوة منفصلة عن برنامج النسخ.

إعدادات blur تعتمد على نسخة Niri المستخدمة؛ فحص syntax نجح على نسخة الجهاز وقت التجميع، وليس ضمانًا أن كل build يدعمها. راجع [validation](docs/VALIDATION.md) وحدود الاختبار.

## توثيق | Documentation

- [Changes & public adaptations](docs/CHANGES.md)
- [Dependencies](docs/DEPENDENCIES.md)
- [Optional system components](docs/OPTIONAL.md)
- [Validation](docs/VALIDATION.md)
- [Credits & licenses](docs/ATTRIBUTION.md)
- [Reviewed source inventory](docs/source-manifest.json)

لأي تحديث: انسخ الملفات المقصودة فقط إلى checkout، راجع `git diff` وافحص الأسرار، ثم حدّث publication manifest بعد المراجعة. لا توجد مزامنة تلقائية من home إلى GitHub.
