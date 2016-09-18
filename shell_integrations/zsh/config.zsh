# Insert this at the top of your zshrc

dotfiles_dir="$HOME/.dotfiles"
export PATH="$PATH:$dotfiles_dir/bin"

for file in $dotfiles_dir/*/*.zsh
do
  source $file
done

