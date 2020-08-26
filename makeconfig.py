#!/usr/bin/python3

import os
import shutil

FORCE_LINK = True

repo_config_dir = os.path.join(os.path.dirname(__file__), "config")
sys_config_dir = os.path.join(os.environ["HOME"], ".config")
os.makedirs(sys_config_dir, exist_ok=True)

for app_dir in os.listdir(repo_config_dir):
    source = os.path.realpath(os.path.join(repo_config_dir, app_dir))
    target = os.path.join(sys_config_dir, app_dir)
    try:
        os.symlink(source, target)
    except OSError:
        print(f"Skipping {target}, file exists")
    
