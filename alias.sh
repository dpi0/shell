alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
# alias /='cd'
alias md='mkdir -p'
alias bd='cd "$OLDPWD"'
alias vf='rga-fzf'
alias cp='rsync -avh --progress --itemize-changes --stats'
alias mvv='rsync -avh --remove-source-files --progress --itemize-changes --stats'
alias rec='asciinema rec'
alias img='loupe'
alias image='loupe'
alias yless="jless --yaml"
alias copy="wl-copy"
alias lf="yazi"
alias notes="note"
alias send-to-phone="qrcp"
alias rm='echo "This is a dangerous command. Use trash instead."'
alias Down='cd $HOME/Downloads/'
alias App='cd $HOME/Applications/'
alias Scr='cd $HOME/Screenshots/'
alias dev='cd $HOME/dev/'
alias Back='cd $HOME/Backup/'
alias Wall='cd $HOME/Wallpapers/'
alias Notes='cd $HOME/Notes/'
alias Books='cd $HOME/Books/'
alias fd='fd -H'
alias password="< /dev/urandom tr -dc 'A-Za-z0-9' | head -c32"
alias delete_from_clipboard="cliphist list | fzf --no-sort | cliphist delete"
alias clipboard="cliphist list | fzf --no-sort | cliphist decode | wl-copy"
alias ram='ps axch -o cmd:15,%mem --sort=-%mem | head'
alias cpu='ps axch -o cmd:15,%cpu --sort=-%cpu | head'
alias mhz='watch -n 1 "cat /proc/cpuinfo | grep MHz"'
alias lightmode='gsettings set org.gnome.desktop.interface color-scheme 'prefer-light''
alias darkmode='gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark''

#alias rm="rm -iv"

# remove all dir and all it's files
alias rmd='rm -i --recursive --force --verbose '

# list all root dirs with their sizes of the current dir
alias sizedir='fd -H -t d -d 1 . . | xargs du -hs | sort -h -r'

alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

alias sudoEs='sudo -E -s'

alias l="eza --icons -a -l --time-style relative --changed"
alias lm="eza --icons -a -l --time-style '+%d %b - %H:%M:%S' --changed"
alias lc="eza --icons -a -l --time-style relative --changed --sort=changed --reverse"
alias ll="eza --icons -l --time-style relative --changed"
alias ls="l"
alias lg="l -g"
alias lt="eza --icons -a -T"
alias br="broot -s"

alias crnew="crontab -e"
alias scrnew="sudo crontab -e"
alias crlist="crontab -l"

alias c="bat"
alias cat="bat"
alias h="history -E 1"
alias j="ji"
alias jj="cd ~"
alias tree="eza --tree --long"
alias re="source ~/.zshrc && exec zsh"
alias tre="tmux source-file $HOME/zsh/.tmux.conf"
alias i="feh -Fd"
alias ufw="sudo ufw"
alias dw="aria2c"
alias pdf="evince"
alias disk="duf"
# alias dust="gdu"
alias size="gdu"
alias play="mpv"
alias lz=lazygit
alias ldd=lazydocker
alias dox=oxker
alias v=nvim
alias sv="sudo vim"
alias ex="extract"
# alias open="dolphin ."
alias open="thunar ."
alias vpndown='sudo wg-quick down'
alias vpnup='sudo wg-quick up'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# DOCKER

alias d="docker"
alias di="docker image"
alias dpsa="docker ps -a"
alias dpt="docker build -t"
alias de="docker exec"

alias dc="docker compose"
alias dce="docker compose exec"
alias dcu="docker compose up"
alias dcd="docker compose down"
alias dcl="docker compose logs"
alias dcb="docker compose build"
alias dcp="docker compose pause"
alias dcup="docker compose unpause"
alias dsta="docker compose start"
alias dsto="docker compose stop"
alias dci="docker compose images"
alias dcls="docker compose ls"
alias dcps="docker compose ps"
alias dct="docker compose top"

alias dr="docker run"
alias drn="docker run --name"
alias drd="docker run -d"
alias dstart="docker start"
alias dstop="docker stop"
alias drestart="docker restart"
alias dlogs="docker logs"
alias drm="docker rm"
alias dstats="docker container stats --all"

alias dlogin="docker login -u"
alias dpush="docker push"
alias dsearch="docker search"
alias dpull="docker pull"

alias dn="docker network"
alias dnl="docker network ls"
alias dni="docker network inspect"
alias dnc="docker network create"
alias dnr="docker network rm"
alias dnp="docker network prune"

alias dv="docker volume"
alias dvl="docker volume ls"
alias dvi="docker volume inspect"
alias dvc="docker volume create"
alias dvr="docker volume rm"
alias dvp="docker volume prune"

alias list-named-vol="docker volume ls | rg -v '^local\s+[a-f0-9]{64}$' | tail -n +2 | awk '{print $2}'"

# Kubernetes aliases
alias mk="minikube"
alias kb="kubectl"

# GIT

alias gi='git init'
forgit_ignore=gii

# GIT ADD
alias ga='git add'
alias gaa='git add --all'
alias gav='git add --verbose'

# GIT BRANCH
alias gb='git branch'
alias gba='git branch --all'
# alias gbd='git branch --delete'
alias gbD='git branch --delete --force'
alias gbm='git branch --move'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'

# GIT CHECKOUT
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcB='git checkout -B'

# GIT CHERRY-PICK
# alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

# GIT CLONE
alias gcl='git clone'

# GIT DIFF
alias gd='git diff'
alias gdc='git diff --cached'
alias gdcs='git diff --cached --stat'
alias gdh='git diff HEAD'
alias gdhs='git diff HEAD --stat'

# GIT COMMIT
alias gcmt='git commit --verbose'

# GIT FETCH
alias gf='git fetch'
alias gfo='git fetch origin'

# GIT LOG
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
# alias glods='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short'
# alias glod='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'
# alias glola='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'
# alias glols='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat'
# alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
# alias glo='git log --oneline --decorate'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'

# GIT MERGE
alias gm='git merge'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gms="git merge --squash"

# GIT PULL
alias gl='git pull'
alias gpr='git pull --rebase'
alias gprv='git pull --rebase -v'
alias gpra='git pull --rebase --autostash'
alias gluc='git pull upstream $(git_current_branch)'
alias glum='git pull upstream $(git_main_branch)'

# GIT PUSH
alias gp='git push'
alias gpd='git push --dry-run'
alias gpv='git push --verbose'
alias gpu='git push upstream'

# GIT REBASE
# alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase --interactive'

# GIT REFLOG
# alias grf='git reflog'

# GIT REMOTE
alias gr='git remote'
alias grv='git remote --verbose'
alias gra='git remote add'
alias grrm='git remote remove'
alias grmv='git remote rename'
alias grset='git remote set-url'
alias grup='git remote update'

# GIT RESET
# alias grh='git reset'
alias gru='git reset --'
alias grhh='git reset --hard'
alias grhk='git reset --keep'
alias grhs='git reset --soft'

# GIT RESTORE
alias grs='git restore'
alias grss='git restore --source'
alias grst='git restore --staged'

# GIT REVERT
alias grev='git revert'
alias greva='git revert --abort'
alias grevc='git revert --continue'

# GIT RM
alias grm='git rm'
alias grmc='git rm --cached'

# GIT SHOW
alias gsh='git show'

# GIT STASH
alias gstall='git stash --all'
alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'

# GIT STATUS
alias gst='git status'

# GIT SWITCH
alias gsw='git switch'
alias gswc='git switch --create'
alias gswd='git switch $(git_develop_branch)'
alias gswm='git switch $(git_main_branch)'

# GIT TAG
alias gta='git tag --annotate'
alias gts='git tag --sign'
alias gtv='git tag | sort -V'

# GIT WORKTREE
alias gwt='git worktree'
alias gwta='git worktree add'
alias gwtls='git worktree list'
alias gwtmv='git worktree move'
alias gwtrm='git worktree remove'

# GIT AM
# alias gam='git am'
# alias gama='git am --abort'
# alias gamc='git am --continue'
# alias gamscp='git am --show-current-patch'
# alias gams='git am --skip'

# GIT APPLY
# alias gap='git apply'
# alias gapt='git apply --3way'

# GIT BISECT
# alias gbs='git bisect'
# alias gbsb='git bisect bad'
# alias gbsg='git bisect good'
# alias gbsn='git bisect new'
# alias gbso='git bisect old'
# alias gbsr='git bisect reset'
# alias gbss='git bisect start'

# GIT BLAME
# alias gbl='git blame -w'

# PACMAN

alias p='pacman' # alias for "paru -Syu"
alias pi='sudo pacman -S' # Update/Install a specific package
alias pqua='sudo pacman -Qua' # Show all available AUR updates
alias pr='sudo pacman -R' # remove the package only
alias prs='sudo pacman -Rs' # Remove a package and its dependencies that are not required by any other installed packages "s" unnecessary dependencies,
alias pn='sudo pacman -Rn' # Remove the specified package and its configuration files "n" it's config files
alias pc='sudo pacman -Rc' # Remove the specified package along with its configuration files. It also removes dependencies that are not required by other installed packages
alias pu='sudo pacman -Ru' # Remove the specified package and its unneeded dependencies. It is more aggressive than -Rs in removing dependencies "u" unneeded packages.
alias prsu='sudo pacman -Rsu' # remove a package from the system, including its dependencies that are not required by any other installed package "u" unneeded packages,
alias prsun='sudo pacman -Rsun' # remove the package, "s" unnecessary dependencies, "u" unneeded packages, "n" it's config files
alias pcheck='pacman -Qi' # Detailed information about a specific installed package i.e., pcheck
alias pqi='pacman -Qi' # Detailed information about a specific installed package i.e., pcheck
alias pcheckfiles='pacman -Ql' # What files does this package have? i.e., pcheckfiles
alias pql='pacman -Ql' # What files does this package have? i.e., pcheckfiles
alias pqo='pacman -Qo' # Who owns this package? i.e., pcheckowner
alias pcheckowner='pacman -Qo' # Who owns this package? i.e., pcheckowner
alias pr_unneeded='sudo pacman -Rns $(pacman -Qdtq)' # Uninstall unneeded packages
alias pq='pacman -Q' # List all installed packages on the system along with their version numbers.
alias pqu='pacman -Qu' # List all packages that have updates available in the repositories.
alias pqdt='pacman -Qdt' # List orphaned packages, i.e., packages that were installed as dependencies but are no longer required by any explicitly installed package. List unneeded packages
alias pqe='pacman -Qe' # Explicitly installed packages are the ones that you specifically requested to be installed. It excludes packages that were installed as dependencies of other packages.
alias pqii='pacman -Qii' # Extended information about explicitly installed packages.
alias pat='pactree' # What does pkg depend on?
alias patr='pactree -r' # What depends on pkg?
alias pss='pacman -Ss' # Search for a package or packages in the repositories.
alias psi='pacman -Si' # Display information about a given package located in the repositories.
alias pqs='pacman -Qs' # Search for a package or packages in the local database.

# PYTHON 

alias py="python3"
alias pipf="pip freeze"
alias pipr="pip freeze > requirements.txt"
alias ponew="poetry new"
alias poin="poetry add"
alias por="poetry remove"
alias pou="poetry update"
alias porun="poetry run"
alias poinstall="poetry install"
alias poin="poetry init"
alias pol="poetry show -tlav"
alias pos="poetry shell"
alias posh="poetry search"
alias polock="poetry lock"
alias pov="poetry version"
alias poab="poetry about"

# SYSTEMCTL

alias ystatus="sudo systemctl status"
alias yliste="systemctl list-unit-files --state=enabled"
alias ylist="sudo systemctl list-unit-files"
alias ystart="sudo systemctl start"
alias ystop="sudo systemctl stop"
alias yblock="sudo systemctl mask"
alias yunblock="sudo systemctl unmask"
alias yrestart="sudo systemctl reload-or-restart"
alias yenable="sudo systemctl enable"
alias ydisable="sudo systemctl disable"

# TMUX

alias t="tmux"
alias ta="tmux a -t"
alias tls="tmux ls"
alias tn="tmux new-session -s"
alias tk="tmux kill-session -t"
alias tka="tmux kill-server"
alias tks="tmux kill-server"

