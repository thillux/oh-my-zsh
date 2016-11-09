if (( $+commands[yaourt] )); then
<<<<<<< HEAD
  upgrade () {
    yaourt -Syua
  }
  alias yaconf='yaourt -C'        # Fix all configuration files with vimdiff
  # Pacman - https://wiki.archlinux.org/index.php/Pacman_Tips
  alias yaupg='yaourt -Syua'        # Synchronize with repositories before upgrading packages (AUR packages too) that are out of date on the local system.
  alias yasu='yaourt --sucre'      # Same as yaupg, but without confirmation
  alias yain='yaourt -S'           # Install specific package(s) from the repositories
  alias yains='yaourt -U'          # Install specific package not from the repositories but from a file
  alias yare='yaourt -R'           # Remove the specified package(s), retaining its configuration(s) and required dependencies
  alias yarem='yaourt -Rns'        # Remove the specified package(s), its configuration(s) and unneeded dependencies
  alias yarep='yaourt -Si'         # Display information about a given package in the repositories
  alias yareps='yaourt -Ss'        # Search for package(s) in the repositories
  alias yaloc='yaourt -Qi'         # Display information about a given package in the local database
  alias yalocs='yaourt -Qs'        # Search for package(s) in the local database
  alias yalst='yaourt -Qe'         # List installed packages, even those installed from AUR (they're tagged as "local")
  alias yaorph='yaourt -Qtd'       # Remove orphans using yaourt
  # Additional yaourt alias examples
=======
  alias yaconf='yaourt -C'
  alias yaupg='yaourt -Syua'
  alias yasu='yaourt -Syua --noconfirm'
  alias yain='yaourt -S'
  alias yains='yaourt -U'
  alias yare='yaourt -R'
  alias yarem='yaourt -Rns'
  alias yarep='yaourt -Si'
  alias yareps='yaourt -Ss'
  alias yaloc='yaourt -Qi'
  alias yalocs='yaourt -Qs'
  alias yalst='yaourt -Qe'
  alias yaorph='yaourt -Qtd'
  alias yainsd='yaourt -S --asdeps'
  alias yamir='yaourt -Syy'


  if (( $+commands[abs] && $+commands[aur] )); then
    alias yaupd='yaourt -Sy && sudo abs && sudo aur'
  elif (( $+commands[abs] )); then
    alias yaupd='yaourt -Sy && sudo abs'
  elif (( $+commands[aur] )); then
    alias yaupd='yaourt -Sy && sudo aur'
  else
    alias yaupd='yaourt -Sy'
  fi
fi

if (( $+commands[pacaur] )); then
  alias paupg='pacaur -Syua'
  alias pasu='pacaur -Syua --noconfirm'
  alias pain='pacaur -S'
  alias pains='pacaur -U'
  alias pare='pacaur -R'
  alias parem='pacaur -Rns'
  alias parep='pacaur -Si'
  alias pareps='pacaur -Ss'
  alias paloc='pacaur -Qi'
  alias palocs='pacaur -Qs'
  alias palst='pacaur -Qe'
  alias paorph='pacaur -Qtd'
  alias painsd='pacaur -S --asdeps'
  alias pamir='pacaur -Syy'

>>>>>>> 0b340bc3a5c58609a07987b296f773eaea17b274
  if (( $+commands[abs] && $+commands[aur] )); then
    alias paupd='pacaur -Sy && sudo abs && sudo aur'
  elif (( $+commands[abs] )); then
    alias paupd='pacaur -Sy && sudo abs'
  elif (( $+commands[aur] )); then
    alias paupd='pacaur -Sy && sudo aur'
  else
    alias paupd='pacaur -Sy'
  fi
fi

if (( $+commands[pacaur] )); then
  upgrade() {
    pacaur -Syu
  }
elif (( $+commands[yaourt] )); then
  upgrade() {
    yaourt -Syu
  }
else
  upgrade() {
    sudo pacman -Syu
  }
fi

# Pacman - https://wiki.archlinux.org/index.php/Pacman_Tips
alias pacupg='sudo pacman -Syu'
alias pacin='sudo pacman -S'
alias pacins='sudo pacman -U'
alias pacre='sudo pacman -R'
alias pacrem='sudo pacman -Rns'
alias pacrep='pacman -Si'
alias pacreps='pacman -Ss'
alias pacloc='pacman -Qi'
alias paclocs='pacman -Qs'
alias pacinsd='sudo pacman -S --asdeps'
alias pacmir='sudo pacman -Syy'
alias paclsorphans='sudo pacman -Qdt'
alias pacrmorphans='sudo pacman -Rs $(pacman -Qtdq)'


if (( $+commands[abs] && $+commands[aur] )); then
  alias pacupd='sudo pacman -Sy && sudo abs && sudo aur'
elif (( $+commands[abs] )); then
  alias pacupd='sudo pacman -Sy && sudo abs'
elif (( $+commands[aur] )); then
  alias pacupd='sudo pacman -Sy && sudo aur'
else
  alias pacupd='sudo pacman -Sy'
fi

paclist() {
  # Source: https://bbs.archlinux.org/viewtopic.php?id=93683
  LC_ALL=C pacman -Qei $(pacman -Qu | cut -d " " -f 1) | \
    awk 'BEGIN {FS=":"} /^Name/{printf("\033[1;36m%s\033[1;37m", $2)} /^Description/{print $2}'
}

pacdisowned() {
  emulate -L zsh

  tmp=${TMPDIR-/tmp}/pacman-disowned-$UID-$$
  db=$tmp/db
  fs=$tmp/fs

  mkdir "$tmp"
  trap  'rm -rf "$tmp"' EXIT

  pacman -Qlq | sort -u > "$db"

  find /bin /etc /lib /sbin /usr ! -name lost+found \
    \( -type d -printf '%p/\n' -o -print \) | sort > "$fs"

  comm -23 "$fs" "$db"
}

pacmanallkeys() {
  emulate -L zsh
  curl -s https://www.archlinux.org/people/{developers,trustedusers}/ | \
    awk -F\" '(/pgp.mit.edu/) { sub(/.*search=0x/,""); print $1}' | \
    xargs sudo pacman-key --recv-keys
}

pacmansignkeys() {
  emulate -L zsh
  for key in $*; do
    sudo pacman-key --recv-keys $key
    sudo pacman-key --lsign-key $key
    printf 'trust\n3\n' | sudo gpg --homedir /etc/pacman.d/gnupg \
      --no-permission-warning --command-fd 0 --edit-key $key
  done
}
