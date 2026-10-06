# SSH agent resolution
#
# The Mac running 1Password is the single root of trust for SSH auth: it holds
# every private key and forwards its agent out to remote hosts (see the
# ForwardAgent entries in ~/.ssh/config). Remote hosts never hold key material
# of their own, so all they have to do is point at the forwarded agent.
#
#   1Password socket present -> talk to it directly (the Mac)
#   otherwise                -> adopt the agent forwarded by the current login
#
# The wrinkle: sshd allocates a *fresh* socket per login, at a path like
# /tmp/ssh-XXXXXX/agent.1234. A long-lived tmux session captures whatever
# SSH_AUTH_SOCK held when it was created, so after you disconnect and
# reconnect, every pane is pointing at a socket that no longer exists.
#
# Fix: symlink the live socket to one stable path and export *that*. Each new
# login refreshes the symlink, so panes created later always reach whichever
# agent is currently forwarded, without having to know its real path.

_onepassword_agent=$HOME/.1password/agent.sock
_pinned_agent=$HOME/.ssh/agent.sock

if [[ -S $_onepassword_agent ]]; then
    # Workstation: 1Password is already a stable path, nothing to pin.
    export SSH_AUTH_SOCK=$_onepassword_agent
else
    # Remote: if this login arrived with a working forwarded agent, re-point
    # the stable path at it.
    if [[ -n $SSH_AUTH_SOCK && $SSH_AUTH_SOCK != $_pinned_agent ]] \
        && ssh-agent-reachable $SSH_AUTH_SOCK; then
        mkdir -p ${_pinned_agent:h}
        ln -sfn $SSH_AUTH_SOCK $_pinned_agent
    fi

    # No forwarded agent and the pin is dead (e.g. a login without -A, or the
    # forwarding session ended): fall back to the host's own systemd user agent,
    # which holds the devenv key (see ~/.gitconfig-devenv). Only re-point when
    # the pin is dead, so a live forwarded agent always wins.
    _host_agent=${XDG_RUNTIME_DIR:-/run/user/$UID}/openssh_agent
    if ! ssh-agent-reachable $_pinned_agent && ssh-agent-reachable $_host_agent; then
        mkdir -p ${_pinned_agent:h}
        ln -sfn $_host_agent $_pinned_agent
    fi

    # The host agent starts empty after every boot. On hosts that hold their
    # own key, load it on the first interactive login so unattended work
    # (tmux, background agents, git signing) has it until the next reboot.
    # ssh-add -l exits 1 when the agent answers but holds no identities, so
    # this prompts once per boot and is skipped when the agent is unreachable.
    _host_key=$HOME/.ssh/id_ed25519
    if [[ -o interactive && -t 0 && -f $_host_key ]]; then
        SSH_AUTH_SOCK=$_host_agent ssh-add -l >/dev/null 2>&1
        (( $? == 1 )) && SSH_AUTH_SOCK=$_host_agent ssh-add $_host_key
    fi
    unset _host_agent _host_key

    # Adopt the stable path whenever something is listening on it. This is what
    # rescues tmux panes that inherited a dead socket from an older login.
    ssh-agent-reachable $_pinned_agent && export SSH_AUTH_SOCK=$_pinned_agent
fi

unset _onepassword_agent _pinned_agent
