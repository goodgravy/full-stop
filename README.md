# Full Stop

Rather than following a "fork and change" model for dotfiles, this repository
provides tooling and conventions to be included in your own dotfiles as a git
subtree or submodule.

The idea is to keep the utilities which _manage_ your dotfiles separate from
the _content_ of the dotfiles themselves. In this way, we should be able to
re-use, share, and improve the tooling much more easily, independent of our
individual environment preferences.

The approach taken is based on Zach Holman's excellent
[dotfiles](https://github.com/holman/dotfiles).

## What does Full Stop do for me?

After you [include Full Stop in your dotfiles](#usage), just run the included
`full-stop` script. Using your configuration it will:

* create symlinks in your `$HOME`
* install dependencies
* configure OS settings
* modify your shell environment
* and much, much more

You can re-run `full-stop` anytime you want to update your configuration and
dependencies.

## What do I need to do to use Full Stop?

Full Stop defines a couple of simple conventions for how your dotfiles
configuration should be laid out and specified.

### System dependencies

Create a [Brewfile](https://github.com/Homebrew/homebrew-bundle) in your
dotfiles repository. This is a list of applications for [Homebrew
Cask](http://caskroom.io) to install.

### Executables

To add new executables to your `$PATH`, create a `./bin` directory in your
dotfiles repository and put the scripts or binaries in there.

### Other configuration and dependencies

Full Stop uses holman's idea of _topic areas_. For each logical topic that you
have configuration or dependencies for, just create a directory in your
dotfiles repository with a descriptive name. For example, you might have
directories called `ruby`, `node`, `vim`, `atom`, etc..

Full Stop follows some simple rules when processing the files in these
directories:

* files named `setup.sh` will be run as part of the `full-stop` command,
  they're normally used to install software and set OS configuration
* other files named like `my-script.sh` will be sourced into the environment of
  every new shell (see the `shell_integrations` directory)
* files named like `my-file.symlink` will be symlinked to `$HOME/.my-file`
* files named like `a-directory/a-file.symlink` will be symlinked to
  `$HOME/.a-directory/a-file`
* files named like `my-config.linkto` will symlink the corresponding source file
  to the arbitrary path specified inside the `.linkto` file (see
  [Linking to arbitrary paths](#linking-to-arbitrary-paths))
* files named `teardown.sh` will be run when `full-stop --unlink` is used, to
  undo side effects of `setup.sh`

Example of symlinking:

```sh
~/.dotfiles $ tree .
.
├── topic_A
│   └── a-configuration-file.symlink
└── topic_B
    └── config_directory
        └── a-nested-file.symlink

~/.dotfiles $ full-stop/script/full-stop
[...]

~/.dotfiles $ tree -a $HOME
/Users/goodgravy
├── [...]
├── .a-configuration-file -> /Users/goodgravy/.dotfiles/topic_A/a-configuration-file.symlink
└── .config_directory
    └── a-nested-file -> /Users/goodgravy/.dotfiles/topic_B/config_directory/a-nested-file.symlink
```

## Usage

First, create your dotfiles repository:

```sh
mkdir ~/.dotfiles
cd ~/.dotfiles
git init
echo > Brewfile
git add Brewfile
git commit -m 'Initial commit'
```

Then, add Full Stop as a git submodule (subtrees also work, but come with [some
problems](http://git.661346.n2.nabble.com/subtree-merges-lose-prefix-after-rebase-td7332850.html)):

```sh
git submodule add git@github.com:goodgravy/full-stop.git full-stop
```

Then, run the `full-stop` script:

```sh
./full-stop/script/full-stop
```

On the first run, this won't do much. Add some configuration following the
[Full Stop conventions](#what-do-I-need-to-do-to-use-full-stop) to really get
going!

You can re-run the `full-stop` script whenever you want to update your
dependencies, or if you have changed your dotfiles configuration and want to
apply the changes.

If you want to benefit from upstream changes to Full Stop, just update the
submodule:

```sh
git submodule update --remote
```

## Example

You can find my dotfiles (which use Full Stop as described above) in
[goodgravy/dotfiles](//github.com/goodgravy/dotfiles).

### I want to create a `~/.bashrc` file

Easy-peasy:

```sh
~/.dotfiles $ mkdir bash
~/.dotfiles $ touch bash/bashrc.symlink
~/.dotfiles $ ./full-stop/script/full-stop
  [ .. ] brew update
  [ .. ] installing dotfiles
  [ OK ] linked /Users/goodgravy/.dotfiles/bash/bashrc.symlink to /Users/goodgravy/.bashrc
  [ OK ] Full Stop complete
~/.dotfiles $ tree -a $HOME
/Users/goodgravy
├── [...]
└── .bashrc -> /Users/goodgravy/.dotfiles/bash/bashrc.symlink
```

### I want to create a `~/.config/nvim/` directory

Lemon-squeezy:

```sh
~/.dotfiles $ mkdir -p neovim/config/nvim.symlink
~/.dotfiles $ touch neovim/config/nvim.symlink/init.vim
~/.dotfiles $ ./full-stop/script/full-stop
  [ .. ] brew update
  [ OK ] linked /Users/goodgravy/.dotfiles/neovim/config/nvim.symlink to /Users/goodgravy/.config/nvim
  [ OK ] Full Stop complete

~/.dotfiles $ tree -l ~/.config/
/Users/goodgravy/.config/
└── nvim -> /Users/goodgravy/.dotfiles/neovim/config/nvim.symlink
    └── init.vim
```

As you can see, Full Stop doesn't care if your symlinks are files or
directories, and it can create symlinks inside of "dot directories" as well as
dotfiles directly in $HOME (e.g. inside the `~/.config` directory as shown
above).

### Linking to arbitrary paths

Not all config files live at `$HOME/.<name>`. For files that need to go
somewhere else entirely, use a `.linkto` sidecar file. The sidecar contains the
full destination path:

```sh
~/.dotfiles $ tree ghostty/
ghostty/
├── config                  # the actual config file
└── config.linkto           # contains the destination path

~/.dotfiles $ cat ghostty/config.linkto
~/Library/Application Support/com.mitchellh.ghostty/config

~/.dotfiles $ ./full-stop/script/full-stop ghostty
  [ .. ] installing linkto files
  [ OK ] created directory /Users/goodgravy/Library/Application Support/com.mitchellh.ghostty
  [ OK ] linked /Users/goodgravy/.dotfiles/ghostty/config to /Users/goodgravy/Library/Application Support/com.mitchellh.ghostty/config
  [ OK ] Full Stop complete (topics: ghostty)
```

The `.linkto` convention parallels `.symlink`: where `.symlink` says "link me to
the conventional `~/.name` place", `.linkto` says "link me to the explicit path
I specify". Intermediate directories are created automatically. Paths with
spaces are handled correctly.

## CLI reference

```
full-stop [OPTIONS] [TOPIC ...]
```

| Option | Description |
|---|---|
| _(no args)_ | Full run: pull, brew, all topics, all symlinks |
| `TOPIC ...` | Only process named topics (skips brew and pull) |
| `--dry-run` / `--plan` | Show what would happen without making changes |
| `--unlink` | Remove symlinks managed by full-stop |
| `--unlink TOPIC` | Remove only symlinks from named topics |
| `--no-brew` | Skip homebrew update and bundle |
| `--with-brew` | Force homebrew even with topic selection |
| `--no-pull` | Skip git pull and submodule update |
| `--list-topics` | List available topics and exit |

Flags compose freely: `full-stop --unlink --dry-run git` previews what
unlinking the git topic would do.
