# First load starship
use ~/.cache/starship/init.nu
use ~/.config/nushell/completions/git-completions.nu *

# Remove the banner
$env.config.show_banner = false

$env.config.edit_mode = "vi"
$env.config.buffer_editor = "nvim"

$env.PATH = ($env.PATH | split row (char esep) | append "/home/adrian/.foundry/bin")
$env.PATH = ($env.PATH | append "/home/adrian/Downloads/google-cloud-cli-linux-x86_64/google-cloud-sdk/bin")

$env.PATH = ($env.PATH | append "/usr/local/go/bin")
$env.PATH = ($env.PATH | append "/home/adrian/go/bin")
$env.PATH = ($env.PATH | append "/home/adrian/.cargo/bin")
$env.PATH = ($env.PATH | prepend '~/.npm-global/bin')

# Then load zoxide
source ~/.zoxide.nu

# Aliases
alias tma = tmux attach-session
alias tmk = tmux kill-server

def s [] {
    let session = (sesh list -i | gum filter --limit 1 --fuzzy --no-sort --placeholder "Pick a sesh" --prompt "⚡")
    sesh connect $session
}

# Load ssh-agent
keychain --eval --quiet id_ed25519  # adjust key name as needed
    | lines
    | where not ($it | is-empty)
    | parse "{k}={v}; export {k2};"
    | select k v
    | transpose --header-row
    | into record
    | load-env

def greet [] {
    macchina
}

greet
