#!/usr/bin/env python3
"""Review first; copy a curated payload with per-file backup and rollback."""
import argparse
import hashlib
import json
import os
import shutil
import sys
import tempfile
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EXECUTABLES = set(json.loads((ROOT/'docs/executable-paths.json').read_text()))


def safe_path(home, relative):
    rel = Path(relative)
    if rel.is_absolute() or '..' in rel.parts:
        raise ValueError('Invalid relative path')
    out = home / rel
    for parent in out.parents:
        if parent == home:
            break
        if parent.is_symlink():
            raise ValueError(f'Refusing symlink parent: {parent}')
    return out


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def replace(src, target, home, relative):
    target.parent.mkdir(parents=True, exist_ok=True)
    text = src.read_text().replace('@HOME@', str(home))
    with tempfile.NamedTemporaryFile(dir=target.parent, delete=False) as f:
        temp = Path(f.name)
        f.write(text.encode())
    try:
        temp.chmod(0o755 if relative in EXECUTABLES else 0o644)
        temp.replace(target)
    finally:
        temp.unlink(missing_ok=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--apply', action='store_true', help='Write files; default only previews')
    parser.add_argument('--target', type=Path, default=Path.home(), help='Home directory or isolated test directory')
    parser.add_argument('--only', action='append', choices=['niri','waybar','rofi','kitty','nvim','helix','yazi','fastfetch','btop','cava','swaync','swaylock','gtk-3.0','gtk-4.0','fontconfig','qt5ct','qt6ct','matugen','environment.d','systemd','fish','shell','themes','bin','noctalia'])
    parser.add_argument('--restore', type=Path, help='Restore a backup created by this script')
    args = parser.parse_args()
    home = args.target.expanduser().resolve()
    if any(c in str(home) for c in '\n\r"\\'):
        raise ValueError('Target contains characters unsupported by the configuration formats')
    if args.restore:
        backup = args.restore.expanduser().resolve()
        state = json.loads((backup/'manifest.json').read_text())
        if state['target'] != str(home):
            raise ValueError('Backup target differs from --target')
        for entry in state['files']:
            target = safe_path(home, entry['path'])
            if not target.is_file() or target.is_symlink() or digest(target) != entry['installed_sha256']:
                raise ValueError(f'Changed after install; resolve manually: {target}')
        for entry in reversed(state['files']):
            target = safe_path(home, entry['path'])
            print('RESTORE', entry['path'])
            if args.apply:
                target.unlink()
                if entry['existed']:
                    shutil.copy2(backup/'original'/entry['path'], target, follow_symlinks=False)
        return
    choices = set(args.only or [])
    candidates = []
    for top in ['.config','.local','.bashrc','.bash_profile']:
        p = ROOT/top
        candidates.extend(p.rglob('*') if p.is_dir() else [p])
    if 'noctalia' in choices:
        candidates.extend((ROOT/'optional/noctalia/.config').rglob('*'))
    selected = []
    for src in sorted(candidates):
        if src.is_dir():
            continue
        if src.is_symlink():
            raise ValueError('Source symlinks are not allowed')
        rel = str(src.relative_to(ROOT))
        if rel.startswith('optional/noctalia/'):
            rel = rel.removeprefix('optional/noctalia/')
        parts = Path(rel).parts
        group = parts[1] if parts[0]=='.config' else ('bin' if rel.startswith('.local/bin/') else 'themes' if rel.startswith('.local/share/') else 'shell')
        if choices and group not in choices:
            continue
        target = safe_path(home, rel)
        if target.exists() and target.is_dir():
            raise ValueError(f'Target is a directory: {target}')
        selected.append((src,rel,target))
    for _,rel,_ in selected:
        print('COPY',rel)
    if not args.apply:
        print(f'Dry run: {len(selected)} files. Add --apply to copy; services/packages are not started/installed.')
        return
    if not selected:
        raise ValueError('No files selected')
    backup_parent = safe_path(home,'.local/state/my-dotfiles/backups')
    if backup_parent.is_symlink():
        raise ValueError('Backup directory cannot be a symlink')
    backup_parent.mkdir(parents=True,exist_ok=True)
    backup = backup_parent/datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ')
    backup.mkdir(mode=0o700)
    state={'target':str(home),'files':[]}
    # Save every previous file before writing any configuration.
    for src,rel,target in selected:
        exists=target.exists() or target.is_symlink()
        if exists:
            original=backup/'original'/rel
            original.parent.mkdir(parents=True,exist_ok=True)
            shutil.copy2(target,original,follow_symlinks=False)
        rendered=src.read_text().replace('@HOME@',str(home)).encode()
        state['files'].append({'path':rel,'existed':exists,'installed_sha256':hashlib.sha256(rendered).hexdigest()})
    (backup/'manifest.json').write_text(json.dumps(state,indent=2)+'\n')
    applied=[]
    try:
        for src,rel,target in selected:
            replace(src,target,home,rel)
            applied.append(rel)
    except OSError:
        for entry in reversed(state['files']):
            if entry['path'] not in applied:
                continue
            target=safe_path(home,entry['path'])
            target.unlink()
            if entry['existed']:
                shutil.copy2(backup/'original'/entry['path'],target,follow_symlinks=False)
        raise
    print(f'Backup: {backup}')
    print('Review configuration before logging out. No live reload was performed.')


if __name__=='__main__':
    try:
        main()
    except (OSError,ValueError,KeyError) as exc:
        print(f'Error: {exc}',file=sys.stderr)
        sys.exit(1)
