#!/usr/bin/env python3
"""Validate curated publication scope without printing matched sensitive text."""
import argparse
import ast
import hashlib
import json
import re
import subprocess
import sys
import tomllib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT/'docs/publication-manifest.json'
CONFIGS = {'niri','waybar','rofi','kitty','nvim','helix','yazi','fastfetch','btop','cava','swaync','swaylock','gtk-3.0','gtk-4.0','fontconfig','qt5ct','qt6ct','matugen','environment.d','systemd','fish','starship.toml'}
FORBIDDEN = {'.env','.ssh','.gnupg','keyrings','sessions','history','backups','__pycache__','fish_variables','fish_history','.bash_history'}
PATTERNS = {
    'private-key': re.compile(r'-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----'),
    'github-token': re.compile(r'\b(?:gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{50,})\b'),
    'cloud-key': re.compile(r'\bAKIA[0-9A-Z]{16}\b'),
    'credential-in-url': re.compile(r'https?://[^\s/]+:[^\s/]+@'),
    'personal-home': re.compile(r'/home/(?!user\b)[A-Za-z0-9_-]+/'),
    'jwt': re.compile(r'\beyJ[A-Za-z0-9_-]{15,}\.[A-Za-z0-9_-]{15,}\.[A-Za-z0-9_-]{15,}\b'),
}


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--refresh-manifest',action='store_true',help='After manual review, record the current allowed files')
    args=parser.parse_args()
    files={}
    failures=[]
    for p in sorted(ROOT.rglob('*')):
        rel=p.relative_to(ROOT)
        if '.git' in rel.parts:
            continue
        if p.is_symlink():
            failures.append(f'{rel}: symlink');continue
        if p.is_dir():
            continue
        if p==MANIFEST:
            continue
        if any(x in FORBIDDEN or x.startswith('.env.') for x in rel.parts) or any(x in p.name for x in ['.bak','.backup','.before-']) or p.suffix in {'.db','.sqlite','.jsonl','.log','.pyc','.pem','.key','.png','.jpg','.gif'}:
            failures.append(f'{rel}: forbidden file')
        if rel.parts[0]=='.config' and (len(rel.parts)<2 or rel.parts[1] not in CONFIGS):
            failures.append(f'{rel}: configuration outside allowlist')
        if rel.parts[0]=='.local' and not (str(rel).startswith('.local/bin/') or str(rel)=='.local/share/omarchy-themes/index.json'):
            failures.append(f'{rel}: local data outside allowlist')
        try:
            text=p.read_text()
        except (UnicodeError,OSError):
            failures.append(f'{rel}: non-text/unreadable file');continue
        for name,pattern in PATTERNS.items():
            if pattern.search(text):failures.append(f'{rel}: {name}')
        try:
            if p.suffix=='.py' or text.startswith('#!/usr/bin/env python3') or text.startswith('#!/usr/bin/python3'):
                ast.parse(text,filename=str(rel))
            if p.suffix=='.json' or str(rel) in {'.config/waybar/config','.config/fastfetch/config.jsonc'}:
                json.loads(text)
            if p.suffix=='.toml':tomllib.loads(text)
            if p.suffix=='.sh' or text.startswith('#!/bin/bash') or text.startswith('#!/usr/bin/env bash') or p.name in {'.bashrc','.bash_profile'}:
                subprocess.run(['bash','-n',str(p)],check=True,capture_output=True)
        except (ValueError,SyntaxError,subprocess.CalledProcessError) as exc:
            failures.append(f'{rel}: syntax error ({type(exc).__name__})')
        files[str(rel)]={'sha256':hashlib.sha256(p.read_bytes()).hexdigest()}
    if failures:
        print('\n'.join(failures),file=sys.stderr);return 1
    if args.refresh_manifest:
        MANIFEST.write_text(json.dumps(files,indent=2,sort_keys=True)+'\n')
    else:
        if not MANIFEST.exists():print('Missing publication manifest',file=sys.stderr);return 1
        recorded=json.loads(MANIFEST.read_text())
        if files!=recorded:
            for name in sorted(set(files)|set(recorded)):
                if files.get(name)!=recorded.get(name):print('Changed/unreviewed:',name,file=sys.stderr)
            return 1
    print(f'PASS: {len(files)} text files; publication scope, hashes and syntax checked.')
    return 0


if __name__=='__main__':sys.exit(main())
