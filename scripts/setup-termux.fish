#!/usr/bin/env fish

if not type -q pkg
    echo "Error: Termux pkg not found. Run this inside Termux."
    exit 1
end

set -x DEBIAN_FRONTEND noninteractive

set -l packages \
    openssh \
    git \
    fish \
    tmux \
    neovim \
    starship \
    bat \
    eza \
    fzf \
    fd \
    ripgrep \
    git-delta \
    zoxide \
    atuin \
    jq \
    tree \
    rsync

apt-get update -y
apt-get install -y -o Dpkg::Options::=--force-confnew $packages

mkdir -p ~/.ssh
chmod 700 ~/.ssh

mkdir -p ~/.config/fish/conf.d
mkdir -p ~/.config/bat

printf '%s\n' \
    'fish_vi_key_bindings' \
    '' \
    'set fish_cursor_default line' \
    'set fish_cursor_insert block' \
    'set fish_cursor_replace_one underscore' \
    'set fish_cursor_visual block' \
    '' \
    'set -gx PATH $HOME/.local/bin $HOME/.cargo/bin $HOME/.npm/bin $PATH' \
    '' \
    'alias t="tmux"' \
    'alias v="nvim"' \
    'alias vdiff="nvim -d"' \
    '' \
    'if type -q direnv' \
    '    direnv hook fish | source' \
    'end' \
    '' \
    'if type -q starship' \
    '    starship init fish | source' \
    'end' \
    > ~/.config/fish/conf.d/neurotermux.fish

printf '%s\n' \
    '[character]' \
    'success_symbol = ">"' \
    'error_symbol = ">"' \
    '' \
    '[aws]' \
    'symbol = "A "' \
    > ~/.config/starship.toml

printf '%s\n' \
    '[user]' \
    '    name = Tim Koval' \
    '    email = timkoval00@gmail.com' \
    '' \
    '[init]' \
    '    defaultBranch = main' \
    '' \
    '[push]' \
    '    autoSetupRemote = true' \
    '' \
    '[pull]' \
    '    rebase = true' \
    '' \
    '[url "ssh://git@github.com/"]' \
    '    insteadOf = https://github.com/' \
    '' \
    '[url "ssh://git@gitlab.com/"]' \
    '    insteadOf = https://gitlab.com/' \
    '' \
    '[url "ssh://git@bitbucket.com/"]' \
    '    insteadOf = https://bitbucket.com/' \
    '' \
    '[delta]' \
    '    diff-so-fancy = true' \
    '    line-numbers = true' \
    '    true-color = always' \
    '' \
    '[core]' \
    '    pager = delta' \
    '' \
    '[interactive]' \
    '    diffFilter = delta --color-only' \
    '' \
    '[includeIf "gitdir:~/git-local/at/"]' \
    '    path = ~/git-local/at/.gitconfig' \
    '' \
    '[alias]' \
    '    br = branch' \
    '    co = checkout' \
    '    st = status' \
    '    ls = log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate' \
    '    ll = log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat' \
    '    cm = commit -m' \
    '    ca = commit -am' \
    '    dc = diff --cached' \
    '    amend = commit --amend -m' \
    '    unstage = reset HEAD --' \
    '    merged = branch --merged' \
    '    unmerged = branch --no-merged' \
    '    nonexist = remote prune origin --dry-run' \
    '    delmerged = ! git branch --merged | egrep -v "(^\\*|main|master|dev|staging)" | xargs git branch -d' \
    '    delnonexist = remote prune origin' \
    '    update = submodule update --init --recursive' \
    '    foreach = submodule foreach' \
    > ~/.gitconfig

printf '%s\n' \
    'set-option -g default-shell /data/data/com.termux/files/usr/bin/fish' \
    'set-option -g default-command "fish -i"' \
    '' \
    'unbind r' \
    'bind r source-file ~/.tmux.conf' \
    '' \
    'set -g prefix C-s' \
    'set -g mouse on' \
    '' \
    'unbind -n Up' \
    'unbind -n Down' \
    'unbind -n Left' \
    'unbind -n Right' \
    '' \
    'bind Up select-pane -U' \
    'bind Down select-pane -D' \
    'bind Left select-pane -L' \
    'bind Right select-pane -R' \
    '' \
    'set -g status-position top' \
    '' \
    'set -g @plugin "tmux-plugins/tpm"' \
    'run "~/.tmux/plugins/tpm/tpm"' \
    > ~/.tmux.conf

if not test -d ~/.tmux/plugins/tpm
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
end

printf '%s\n' \
    '--pager="less -FR"' \
    '--theme="gruvbox-light"' \
    > ~/.config/bat/config

if not test -d ~/.config/nvim
    git clone https://github.com/timkoval/neuronvim ~/.config/nvim
end

if type -q chsh
    chsh -s fish
end

echo "Done. Add your SSH keys in ~/.ssh/."
