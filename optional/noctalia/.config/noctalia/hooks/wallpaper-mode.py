#!/usr/bin/python3
"""Choose Noctalia light/dark from the current wallpaper's mean perceived lightness."""
import argparse, fcntl, os, subprocess, sys
from pathlib import Path
from PIL import Image, ImageOps, ImageStat

def run(*args):
    return subprocess.check_output(args,text=True,timeout=20).strip()

def classify(path):
    with Image.open(path) as original:
        img=ImageOps.exif_transpose(original).convert('RGB')
        img.thumbnail((128,128))
        # Rec.709 weighted sRGB brightness: 0=black, 1=white.
        r,g,b=ImageStat.Stat(img).mean
    brightness=(0.2126*r+0.7152*g+0.0722*b)/255
    return ('light' if brightness>=0.55 else 'dark'),brightness

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--inspect',metavar='IMAGE')
    args=parser.parse_args()
    if args.inspect:
        mode,level=classify(args.inspect);print(f'{mode} brightness={level:.3f}');return
    runtime=Path(os.environ.get('XDG_RUNTIME_DIR',f'/run/user/{os.getuid()}'))
    with (runtime/'noctalia-wallpaper-mode.lock').open('w') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX)
        path=run('noctalia','msg','wallpaper-get')
        if not path: return
        mode,level=classify(path)
        current=run('noctalia','msg','theme-mode-get')
        if current!=mode: run('noctalia','msg','theme-mode-set',mode)
        print(f'wallpaper mode={mode} brightness={level:.3f}',flush=True)

if __name__=='__main__':
    try: main()
    except (OSError,ValueError,subprocess.SubprocessError) as exc:
        print(f'wallpaper mode unchanged: {exc}',file=sys.stderr);sys.exit(1)
