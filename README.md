# Dotfiles Substrate

Rather than following a "fork and change" model for dotfiles, this repository
provides tooling and conventions to be included in your own dotfiles as a git
subtree.

The idea is to keep the utilities which _manage_ your dotfiles separate from
the _content_ of the dotfiles themselves. In this way, we should be able to
re-use, share, and improve the tooling much more easily, independent of our
individual environment preferences.

The approach taken is based on Zach Holman's excellent
[dotfiles](https://github.com/holman/dotfiles).

## What does Substrate do for me?

After you [include substrate as a git subtree](#usage) in your own dotfiles
repository, just run the included `substrate` script. Using your configuration
it will:

* create symlinks in your `$HOME`
* install dependencies
* configure OS settings
* modify your shell environment
* and much, much more

You can re-run `substrate` anytime you want to update your configuration and
dependencies.

## What do I need to do to use Substrate?

Substrate defines a couple of simple conventions for how your dotfiles
configuration should be laid out and specified.

### System dependencies

Create a [Brewfile](https://github.com/Homebrew/homebrew-bundle) in your
dotfiles repository. This is a list of applications for [Homebrew
Cask](http://caskroom.io) to install.

### Executables

To add new executables to your `$PATH`, create a `./bin` directory in your
dotfiles repository and put the scripts or binaries in there.

### Other configuration and dependencies

Substrate uses holman's idea of _topic areas_. For each logical topic that you
have configuration or dependencies for, just create a directory in your
dotfiles repository with a descriptive name. For example, you might have
directories called `ruby`, `node`, `vim`, `atom`, etc..

Substrate follows some simple rules when processing the files in these
directories:

* files named `setup.sh` will be run as part of the `substrate` command,
  they're normally used to install software and set OS configuration
* other files named like `my-script.sh` will be sourced into the environment of
  every new shell (see the `shell_integrations` directory)
* files named like `my-file.symlink` will by symlinked to `$HOME/.my-file`
* files named like `a-directory/a-file.symlink` will by symlinked to
  `$HOME/.a-directory/a-file`

Example of symlinking:

```sh
~/.dotfiles $ tree .
.
├── topic_A
│   └── a-configuration-file.symlink
└── topic_B
    └── config_directory
        └── a-nested-file.symlink

~/.dotfiles $ substrate/script/substrate
[...]

~/.dotfiles $ tree -a $HOME
/Users/goodgravy
├── [...]
├── .a-configuration-file -> /Users/goodgravy/.dotfiles/topic_A/a-configuration-file.symlink
└── .config_directory
    └── a-nested-file -> /Users/goodgravy/.dotfiles/topic_B/config_directory/a-nested-file.symlink
```

**Note**: there is currently only an example integration for [fish
shell](https://fishshell.com/) but others would be very easy to add. Send me a
PR!

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

Then, add Substrate as a git subtree:

```sh
git remote add substrate git@github.com:goodgravy/substrate.git
git subtree add --prefix=substrate substrate master
```

Then, run the `substrate` script:

```sh
./substrate/script/substrate
```

On the first run, this won't do much. Add some configuration following the
[Substrate conventions](#what-do-I-need-to-do-to-use-substrate) to really get
going!

You can re-run the `substrate` script whenever you want to update your
dependencies, or if you have changed your dotfiles configuration and want to
apply the changes.

## Example

You can find my dotfiles (which use Substrate as described above) in
[goodgravy/dotfiles](//github.com/goodgravy/dotfiles).
