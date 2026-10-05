# الخصوصية والأمان | Publication policy

نشر dotfiles يحتاج اختيارًا صريحًا للملفات. `.gitignore` وحده لا يحمي الملفات التي دخلت Git مسبقًا أو الأسرار الموجودة داخل ملف إعداد عادي.

## نطاق النشر

- ملفات config ونصوص desktop صغيرة فقط؛ لا ملفات binary أو صور شخصية.
- catalogue الثيمات يحتوي أسماء وروابط public repositories، دون نتائج اختيار المستخدم أو بيانات التحميل.
- network menu يحتوي أوامر عامة ويطلب password وقت التشغيل؛ لا تُحفظ فيه شبكات الجهاز أو passwords.
- SDDM يستخدم userModel وقت التشغيل؛ لا يوجد username ثابت أو password في المصدر.
- لا `.ssh` أو keyrings أو `.docker` أو cloud credentials أو `.claude` أو `.codex` أو `.gemini` أو browser profiles.
- لا app databases أو conversations أو update/download logs أو package inventory أو backups أو history.
- لا clipboard content أو current wallpaper state أو saved battery profile أو service enablement symlinks.

## تعديلات النشر

حُذف سكربت AI usage الذي يقرأ credentials وسجلات المحادثات، ووحداته من Waybar وNiri. أزيلت تعديلات theme script على Code settings وChromium managed policies. استُبدلت صورة SDDM الشخصية بـ SVG عام. حُذفت Qt window geometry وswaylock wallpaper path. توقفت background plugin update checks في نسخة LazyVim المنشورة.

وجدنا في الجهاز قاعدة battery udev تجعل sysfs thresholds قابلة للكتابة للجميع. لم نضمّنها ولم نعدّلها على الجهاز أثناء التجميع. نسخة battery menu المنشورة تطلب `pkexec` لتشغيل helper ثابت بدل الاعتماد عليها.

## فحص تحديثات لاحقة

```bash
python3 scripts/check.py
# بعد مراجعة كل ملف تغيّر، حدّث البصمات فقط:
python3 scripts/check.py --refresh-manifest
gitleaks dir . --redact --no-banner
gitleaks git . --redact --no-banner
git diff --cached
```

يمكن تفعيل hook محلي يطلب check + Gitleaks قبل commit:

```bash
chmod +x .githooks/pre-commit
git config core.hooksPath .githooks
```

يُفحص الملف المرحلي أيضًا حتى لا تخفيه نسخة working tree مختلفة. ملفات الفحص لا تطبع قيمة secret عند اكتشافها. Gitleaks أداة كشف وليست ضمانًا مطلقًا؛ يلزم فحص المحتوى المقصود وmetadata لكل إضافة، خصوصًا screenshots والأصول الجديدة. لا ترفع reports قد تحتوي سياقًا خاصًا.

المراجع: [Gitleaks official project](https://github.com/gitleaks/gitleaks). المرجعان اللذان اقترحهما المستخدم: [X post](https://x.com/x0D7x/status/2106865426886013411)، [~/.dotfiles in 100 Seconds](https://www.youtube.com/watch?v=r_MpUP6aKiQ). تعذر قراءة منشور X (403)، ولم يتوفر transcript للفيديو وقت التجميع؛ لا ننسب قواعد الأمان في هذه الصفحة إلى محتوى لم نتحقق منه.
