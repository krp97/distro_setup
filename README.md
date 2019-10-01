# Distro setup

A bunch of bash scripts that will automate the work of installing all necessary packages and moving dotfiles around. Written to ease the process of setting up a clean distro.
The polybar and rofi configs are not my work and can be found here:

- [polybar](https://github.com/adi1090x/polybar-themes)
- [rofi](https://github.com/davatorium/rofi-themes)

## Installing packages

The `install.sh` script will install all packages listed in the `base_packages` file and then attempt to install those from `user_packages`. User packages are installed using a pacman wrapper, so in order to execute that part of the script you will need to manually install one of these:

- pacaur
- pakku
- pikaur
- yay

In order to test the script before actually installing anything you might want to do a dry run:

```
$ ./install.sh -e
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

The `stow_dotfiles.sh` script will create symlinks in your home directory to all files in the _dotfiles_ directory. Similarly to the previous script, you might want to do an echo only run, as such:

```
$ ./stow_dotfiles.sh -e
 ---# Skipping stow install (package already present)
 ---> Creating symlinks in home to /home/desktop/Desktop/git/distro_setup
WARNING! stowing dotfiles would cause conflicts:
  * existing target is neither a link nor a directory: .Xresources
All operations aborted.

```

In this mode a `--simulate` argument will be passed to stow, so you can see whether the symlinks can be successfully created in you home directory.

For more information on additional options you can pass a `-h` option to both scripts.
