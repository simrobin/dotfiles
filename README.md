# dotfiles

> Largely inspired by https://github.com/ViBiOh/dotfiles

## Installation

```bash
mkdir -p ${HOME}/code/
pushd ${HOME}/code/
git clone https://github.com/simrobin/dotfiles.git
./dotfiles/init
popd
```

### Configuration

You can set following environment variables for customizing installation behavior:

- `DOTFILES_NO_NODE="true"` doesn't perform install of `install/node` file (replace `NODE` by any uppercase filename in `install/` dir)
- `DOTFILES_DOCKER_RUNTIME="orbstack"` selects the container runtime installed by `install/docker` (`colima` by default)

```bash
# Server configuration example

export DOTFILES_NO_GOLANG="true"
export DOTFILES_NO_GPG="true"
export DOTFILES_NO_NODE="true"
export DOTFILES_NO_PASS="true"
export DOTFILES_NO_PYTHON="true"
export DOTFILES_NO_PYTHON_PGCLI="true"
```

## tmux session

The first `alacritty` shell attaches to the running `tmux` session, or creates
it from `~/.tmux-session`. Copy `.tmux-session.example` and adjust it, the file
stays out of the repo:

```bash
cp dotfiles/.tmux-session.example ${HOME}/.tmux-session
```

One window per line, `name:path`. `~` is expanded, blank lines and `#` lines
are ignored, and a path that is not a directory falls back on `${HOME}`.
Without that file, a bare session is created.

- `DOTFILES_TMUX_SESSION="dev"` names the session
- `DOTFILES_TMUX_LAYOUT="${HOME}/.tmux-session"` locates the layout file

## SSH

```bash
ssh-keygen -t ed25519 -a 100 -C "$(whoami)@$(hostname)" -f ~/.ssh/id_ed25519
```

## Brew

Fix it with following command when it's broken.

```bash
sudo chown -R $(whoami) $(brew --prefix)/*
brew doctor
```
