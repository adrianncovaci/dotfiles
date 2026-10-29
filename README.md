# dotfiles

zsh (oh-my-zsh), tmux + sesh, neovim (lazy.nvim), git + delta. Tools come from
`flake.nix`, configs are symlinked by `install.sh`.

## New Linux machine

```bash
sudo apt install -y git zsh ncurses-term      # ncurses-term: terminfo for TERM=alacritty over ssh
sh <(curl -L https://nixos.org/nix/install) --daemon
# open a new shell so nix is on PATH

git clone https://github.com/adrianncovaci/dotfiles ~/dotfiles
~/dotfiles/install.sh                         # symlinks configs (incl. nix.conf with flakes on), clones oh-my-zsh
nix profile add ~/dotfiles                    # nvim, tmux, sesh, rg, fd, node, go, ... (older nix: `nix profile install`)
chsh -s "$(command -v zsh)"                   # log out and back in
```

First `nvim` run installs plugins; `:Mason` installs the language servers.

## Day to day

```bash
cd ~/dotfiles && git pull && nix profile upgrade --all   # pick up changes
nix flake update && git commit -am "flake: update"      # bump tool versions
```

Machine-specific PATHs / tools go in `~/.zshrc.local` (not tracked).
Desktop configs (alacritty, i3, dunst, flameshot) are linked on macOS, or on Linux with `DESKTOP=1 ./install.sh`.
