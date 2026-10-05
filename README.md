# My Dotfiles

إعداداتي اليومية لبيئة **Fedora + Niri + Waybar**، مجمّعة من ملفات الجهاز الفعلية بعد مراجعة ما يصلح للنشر. أحافظ هنا على شكل سطح المكتب، الاختصارات العربية/الإنجليزية، والثيم المتناسق بين الطرفية والمحررات.

My daily **Fedora + Niri + Waybar** setup, collected from the actual system files and reviewed for publication. It preserves the desktop appearance, Arabic/English shortcuts, and a shared theme across terminals and editors. This curated snapshot contains desktop configuration, not a home-directory backup or an application/account export.

## الموجود | Included

| Component | العربية | English |
|---|---|---|
| Niri | إدخال عربي/إنجليزي، التركيز بالماوس، الاختصارات، الأعمدة المتحركة، قواعد الشفافية وblur، وعرض نافذة btop | Arabic/English input, mouse focus, shortcuts, scrolling-column workflow, window opacity/blur rules, btop window width |
| Waybar | مساحات العمل، الساعة، الصوت، السطوع، الشبكة، البطارية، قائمة العتاد، وتبديل لوحة المفاتيح العربية | Workspaces, clock, audio, brightness, network, battery, hardware drawer, Arabic keyboard toggle |
| Rofi | مشغّل التطبيقات، التصنيفات، قائمة الطاقة، وقوائم الخلفيات والثيمات | Launcher, category picker, power menu, wallpaper/theme menus |
| Kitty + Bash/Fish + Starship | أثر المؤشر، الشفافية، الخطوط، اختصارات النسخ والتكبير، وprompt | Cursor trail, transparency, fonts, copy/zoom shortcuts, prompt |
| Theme scripts | اختيار لوحة Omarchy وألوان الخلفية عبر Matugen، مع مزامنة أدوات سطح المكتب والمحررات | Omarchy palette picker + Matugen wallpaper colors; Niri/Waybar/Kitty/Rofi/GTK/Qt/Helix/btop/SwayNC/swaylock/Fastfetch/Neovim |
| Neovim | LazyVim Starter مع لوحة ألوان سطح المكتب؛ lockfile للإضافات دون cache أو سجل تحديثات | LazyVim Starter with live desktop palette integration; plugin lockfile, no plugin caches or update history |
| Helix + Yazi | مظهر المحرر واختصاراته وإضافة smart-enter | Editor appearance/keymaps and smart-enter plugin |
| Optional | لوحة wvkbd عربية، ثيم SDDM Cruze Noir بصورة عامة، مساعد البطارية، وhook قديم لـ Noctalia | Custom Arabic wvkbd layout, Cruze Noir SDDM theme with generic avatar, battery helper, legacy Noctalia hook |

## الخصوصية | Privacy

لا يحتوي المستودع على browser profiles أو credentials أو محادثات AI أو API keys أو cookies أو clipboard history أو SSIDs محفوظة أو بيانات تطبيقات أو صور شخصية. لا توجد قائمة بجميع التطبيقات المثبتة أو سجلات/ملفات تحديثاتها. أسماء أدوات سطح المكتب تظهر فقط حيث تحتاجها الإعدادات.

The repository excludes browser profiles, credentials, AI conversations, API keys, cookies, clipboard history, saved SSIDs, application data, and personal photos. It contains no full installed-application inventory or application update files/logs. Desktop tool names appear only where the configuration needs them.

أزيلت وحدات AI quota/account usage من نسخة Waybar العامة. لا نجمع `.config` بالكامل.

AI quota/account-usage modules were removed from the public Waybar configuration. We do not collect the entire `.config` directory.

## الاستعادة | Restore

راجع [dependencies](docs/DEPENDENCIES.md) أولًا. النسخ لا يثبّت حزمًا ولا يبدأ services ولا يغيّر ملفات `/etc`.

Read the [dependencies](docs/DEPENDENCIES.md) first. The installer copies configuration; it does not install packages, start services, or modify `/etc`.

```bash
git clone https://github.com/AhmadRun/My-Dotfiles.git
cd My-Dotfiles
python3 scripts/check.py
python3 scripts/install.py                 # preview only
python3 scripts/install.py --only kitty --only rofi --only bin
python3 scripts/install.py --apply           # selected user configuration + backup
```

`--only` قابل للتكرار؛ عند عدم تحديده تُنسخ إعدادات المستخدم الأساسية كلها. عند اختيار أجزاء، اختر dependencies معها: Niri/Waybar/Rofi تحتاج `bin`، وtheme picker يحتاج `themes`. الـ hooks القديمة لـ Noctalia تُنسخ فقط عند طلب `--only noctalia`، ولا تُفعّل تلقائيًا.

`--only` can be repeated. Without it, all core user configurations are selected. Include dependencies when selecting components: Niri/Waybar/Rofi need `bin`, and the theme picker needs `themes`. Legacy Noctalia hooks are copied only with `--only noctalia` and are not enabled automatically.

`@HOME@` يتحول أثناء الاستعادة إلى مسار المستخدم الجديد. لا تستخدم `cp -r` لكل المستودع لأن بعض الإعدادات تحتاج هذا التحويل. صلاحيات تشغيل السكربتات تُضبط من `docs/executable-paths.json` عند الاستعادة؛ ملفات الرفع عبر GitHub Web تُحفظ كـ text عادية. البرنامج يرفض symlink parents، ويحفظ الملفات الموجودة داخل backup خاص بالمستخدم، ولا يحمّل برامج من الإنترنت.

`@HOME@` is replaced with the new user’s home path during installation. Do not copy the entire repository with `cp -r`, because some configurations need this substitution. Script permissions are restored from `docs/executable-paths.json`; GitHub Web uploads store files as ordinary text files. The installer rejects symlink parents, backs up existing files locally, and does not download software.

```bash
# استخدم مسار Backup الذي يظهر بعد النسخ / Use the backup path printed after installation
python3 scripts/install.py --restore "$HOME/.local/state/my-dotfiles/backups/<backup-id>"
python3 scripts/install.py --restore "$HOME/.local/state/my-dotfiles/backups/<backup-id>" --apply
```

التراجع يرفض حذف ملف تغيّر بعد الاستعادة؛ عندها راجع الفرق يدويًا. لا يحذف ملفات أخرى داخل مجلدات إعداداتك. ملفات backup قد تحتوي إعداداتك السابقة الخاصة؛ تبقى محلية ولا تُرفع.

Rollback refuses to remove a file changed after installation; review those differences manually. It leaves unrelated configuration files intact. Backups may contain private settings from your previous setup; keep them local and never upload them.

## الاستخدام | Workflow

| Shortcut | العربية | English |
|---|---|---|
| `Super+T` | الطرفية Kitty | Kitty |
| `Super+D` | مشغّل Rofi | Rofi launcher |
| `Super+Ctrl+Space` | اختيار الثيم | Theme picker |
| `Super+Shift+W` | اختيار الخلفية | Wallpaper picker |
| `Super+Space` | تبديل الإنجليزية/العربية | English/Arabic layout |
| `Super+Alt+K` | لوحة مفاتيح عربية على الشاشة | Arabic on-screen keyboard |
| `Super+Ctrl+B` | قائمة البطارية والطاقة | Battery/power profile menu |
| `Super+N` | الإشعارات | Notifications |
| `Super+Ctrl+F` | الملفات | Files |
| `Super+Alt+L` | قفل الشاشة | Screen lock |

ضع خلفياتك بنفسك في `~/Pictures/Wallpaper-Collection/Wallpapers`. الصور والثيمات المحمّلة ليست داخل Git. اختيار ثيم من catalogue يقوم بتحميله من مستودعه العام؛ راجع المصدر والترخيص قبل استخدامه. `omarchy-theme --previews` اختياري ويحمل صور preview. تشغيل Neovim لأول مرة قد يحمّل plugins عبر LazyVim؛ هذه خطوة منفصلة عن برنامج النسخ.

Add your wallpapers to `~/Pictures/Wallpaper-Collection/Wallpapers`. Downloaded images and themes are not stored in Git. Selecting a catalogue theme downloads it from its public repository; review its source and license first. Optional `omarchy-theme --previews` downloads preview images. Starting Neovim for the first time may download plugins through LazyVim; this is separate from the configuration installer.

إعدادات blur تعتمد على نسخة Niri المستخدمة؛ فحص syntax نجح على نسخة الجهاز وقت التجميع، وليس ضمانًا أن كل build يدعمها. راجع [validation](docs/VALIDATION.md) وحدود الاختبار.

Blur settings depend on your Niri build. Syntax validation passed on the system build used when collecting this snapshot; support is not guaranteed for every build. See [validation](docs/VALIDATION.md) for testing limits.

## توثيق | Documentation

- [التعديلات والنسخة العامة | Changes & public adaptations](docs/CHANGES.md)
- [المتطلبات | Dependencies](docs/DEPENDENCIES.md)
- [مكوّنات النظام الاختيارية | Optional system components](docs/OPTIONAL.md)
- [التحقق | Validation](docs/VALIDATION.md)
- [المصادر والتراخيص | Credits & licenses](docs/ATTRIBUTION.md)
- [قائمة المصادر المراجعة | Reviewed source inventory](docs/source-manifest.json)

لأي تحديث: انسخ الملفات المقصودة فقط إلى checkout، راجع `git diff` وافحص الأسرار، ثم حدّث publication manifest بعد المراجعة. لا توجد مزامنة تلقائية من home إلى GitHub.

For updates, copy only the intended files into the checkout, review `git diff`, scan for secrets, and then refresh the publication manifest. There is no automatic synchronization from home to GitHub.
