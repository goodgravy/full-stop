# Dotfiles Substrate

Rather than following a "fork and change" model for dotfiles, this repository
provides tooling and conventions to be included in your own dotfiles as a git
subtree.

The idea is to keep the utilities which manage your dotfiles separate from the
content of the dotfiles themselves. In this way, we should be able to re-use,
share, and improve the tooling much more easily, independent of our individual
environment preferences.

The approach taken is based on Zach Holman's excellent
[dotfiles](https://github.com/holman/dotfiles).

## What does Substrate do for me?

After you [include substrate as a git subtree](#usage) in your own dotfiles
repository, just run the `substrate` command. Using your configuration it will:

* create symlinks in your `$HOME`
* install dependencies
* configure OS settings
* modify your shell environment
* and much, much more

## What do I need to do to use Substrate?

Substrate defines a couple of simple conventions for how your dotfiles
configuration should be laid out and specified.

### System dependencies

Create a `Brewfile` in your dotfiles repository. This is a list of applications
for [Homebrew Cask](http://caskroom.io) to install.

### Executables

To add new executables to your `$PATH`, create a `./bin` directory in your
dotfiles repository and put the scripts or binaries in there.

### Other configuration and dependencies

Substrate uses holman's idea of _topic areas_. For each logical topic that you
have configuration or dependencies for, just create a directory in your
dotfiles repository with a descriptive name.

Substrate follows some simple rules when processing the files in these
directories:

* files named like `my-file.symlink` will by symlinked to `$HOME/.my-file`
* files named `setup.sh` will be run as part of the `substrate` command,
  they're normally used to install software and set OS configuration
* other files named like `my-script.sh` will be sourced into the environment of
  every new shell (see the `shell_integrations` directory)

## Usage First, create your dotfiles repository:

```sh
mkdir ~/.dotfiles cd ~/.dotfiles git init echo > Brewfile git add
.gitignore git commit -m 'Initial commit'
```

Then, add Substrate as a git subtree:

```sh
git remote add substrate git@github.com:goodgravy/substrate.git git
subtree add --prefix=substrate substrate master
```

Then, run the `substrate` script:

```sh
./substrate/bin/substrate
```
