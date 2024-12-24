# First load starship
use ~/.cache/starship/init.nu
use ~/.config/nushell/completions/git-completions.nu *

# Then load zoxide
source ~/.zoxide.nu

$env.config = ($env.config | upsert keybindings [
    {
        name: "jj-escape-1"
        modifier: none
        keycode: char_j
        mode: [vi_insert]
        event: { edit: InsertChar value: "j" }
    }
    {
        name: "jj-escape-2"
        modifier: none
        keycode: char_j
        mode: [vi_insert]
        event: { 
            edit: BackspaceWord
            send: Esc
        }
    }
])

# Remove the banner
$env.config.show_banner = false

$env.config.edit_mode = "vi"
$env.config.buffer_editor = "nvim"

$env.PATH = ($env.PATH | split row (char esep) | append "/home/adrian/.foundry/bin")
$env.PATH = ($env.PATH | append "/home/adrian/Downloads/google-cloud-cli-linux-x86_64/google-cloud-sdk/bin")

$env.PATH = ($env.PATH | append "/usr/local/go/bin")
$env.PATH = ($env.PATH | append "/home/adrian/go/bin")

def s [] {
    let session = (sesh list -i | gum filter --limit 1 --fuzzy --no-sort --placeholder "Pick a sesh" --prompt "⚡")
    sesh connect $session
}

# Load ssh-agent
do --env {
    let ssh_agent_file = (
        $nu.temp-path | path join $"ssh-agent-($env.USER? | default $env.USERNAME).nuon"
    )

    if ($ssh_agent_file | path exists) {
        let ssh_agent_env = open ($ssh_agent_file)
        if ($"/proc/($ssh_agent_env.SSH_AGENT_PID)" | path exists) {
            load-env $ssh_agent_env
            return
        } else {
            rm $ssh_agent_file
        }
    }

    let ssh_agent_env = ^ssh-agent -c
        | lines
        | first 2
        | parse "setenv {name} {value};"
        | transpose --header-row
        | into record
    load-env $ssh_agent_env
    $ssh_agent_env | save --force $ssh_agent_file
}

def greet [] {
    macchina
}

greet
