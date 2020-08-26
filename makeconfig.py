#!/usr/bin/python3

import os
import shutil

repo_config_dir = os.path.join(os.path.dirname(__file__), "config")
repo_dotfiles_dir = os.path.join(os.path.dirname(__file__), "dotfiles")

sys_config_dir = os.path.join(os.environ['HOME'], ".config")
os.makedirs(sys_config_dir, exist_ok=True)

print(f"Creating symlinks for config/ in {sys_config_dir}")
for app_dir in os.listdir(repo_config_dir):
    source = os.path.realpath(os.path.join(repo_config_dir, app_dir))
    target = os.path.join(sys_config_dir, app_dir)
    try:
        os.symlink(source, target)
    except OSError:
        print(f"\t --> Skipping {target} -> {source}, file exists")


print(f"\nCreating symlinks for dotfiles/ in {os.environ['HOME']}")
for dotfile in os.listdir(repo_dotfiles_dir):
    source = os.path.realpath(os.path.join(repo_dotfiles_dir, dotfile))
    target = os.path.join(os.environ['HOME'], dotfile)
    try:
        os.symlink(source, target)
    except OSError:
        print(f"\t --> Skipping {target} -> {source}, file exists")
