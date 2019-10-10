# Distro setup

A bunch of bash scripts that will automate the work of installing all of the necessary packages and dotfiles on a fresh ArchLinux based distro. Polybar, Rofi and Xresoures files are premade configs with slightly altered color schemes. The original files and much more can be found here:

- [polybar](https://github.com/adi1090x/polybar-themes)
- [rofi](https://github.com/davatorium/rofi-themes)
- [Xresources](https://github.com/logico-dev/Xresources-themes)

Additionally the `.bashrc` script is just a stripped down version of the Manjaro-i3 default config.

## Installing packages

The `install.sh` script will attempt to install all packages listed in the `base_packages` & `user_packages` files. User packages are installed using a pacman wrapper, so in order to execute that part of the script you will need to pass the `-u` option and manually (for now) install one of these:

- pacaur
- pakku
- pikaur
- yay

If you would like to run the script without making any changes, use the `-e` option:

```
$ ./install.sh -e -u
---> Installing base packages
---> Dry run mode --- skipping install
---> Installing base packages --- done
--------------* Danger zone *--------------
---> Installing packages from AUR
---> Checking for pacman wrappers
	---> pacaur found
---> Using pacaur to install user packages
---> Verifying packages from user_packages file
	---> visual-studio-code-bin found
	---> spotify found
	---> polybar found
---> Installing user packages
---> Dry run mode --- skipping install
```

## Dotfiles

The `run_stow.sh` script will create symlinks in your home directory pointing to all files in the `dotfiles/` directory. Similarly to the previous script, you might want to do an echo only run:

```
$ ./run_stow.sh -e
 ---# Skipping stow install (package already present)
 ---> Creating symlinks in home to /home/desktop/Desktop/git/distro_setup
 ---> Checking for file conflicts
 ---> All done
```

You can overwrite already existing configs by passing the `-f` option:

```
$ ./run_stow.sh -e -f
 ---# Skipping stow install (package already present)
 ---> Creating symlinks in home to /home/desktop/Desktop/git/distro_setup
 ---> Checking for conflicts with stow
 ---> Overwriting .Xresources
 ---> Overwriting .bashrc
 ---> Overwriting .dmenurc
 ---> Overwriting .vimrc
 ---> Overwriting aliases.sh
 ---> Overwriting functions.sh
 ---> All done
```

Keep in mind that this will replace all conflicting files, with symlinks to dotfiles in the repository. All overwritten files will be stored in the `backup/` directory at the top of the repo source tree.

If you do not like a particular dotfile, simply move it outside of the `dotfiles/` directory.

For more information on additional options you can pass a `-h` option to both scripts.
