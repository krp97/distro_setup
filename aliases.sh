alias ll="ls -l"

# You're gonna need fzf for this one.
alias pacs="pacman -Slq | fzf -m --preview 'pacman -Si {1}' | xargs -r sudo pacman -S"

alias pipfi='pip freeze | grep -vFxf ~/ignore_requirements.txt'
alias ssrasp='ssh pi@raspberrypi.local'
alias nuke='killall'
alias gogit='cd ~/Desktop/git'

# Manjaro improvement aliases
alias cp='cp -i'
alias df='df -h'
alias more='less'
alias np='nano -w PKGBUILD'