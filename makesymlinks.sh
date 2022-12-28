#!/bin/bash
######################################################################
# This script creates symlinks from the home directory to any desired
# configfiles in ~/configfiles
######################################################################

########## Variables

dir=~/configfiles # configfiles directory
olddir=~/.configfiles_old # old configfiles backup directory
files="bashrc vimrc vim gitconfig screenrc tmux.conf git-completion.bash
dircolors tmux gdbinit" # list of files/directories to symlink in homedir

##########

# create configfiles_old in homedir
echo "Creating $olddir for backup of any existing configfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the configfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# remove any previous symbolic links
echo "Removing any previous symbolic links"
rm $dir/git-completion.bash $dir/tmux.conf

# Detect git version number to load appropriate completion file
GIT_VERSION=$(git --version | cut -d' ' -f3)
if [ -f $dir/git-completion.bash_v$GIT_VERSION ]; then
  ln -s $dir/git-completion.bash_v$GIT_VERSION $dir/git-completion.bash
else
  # If file corresponding to local git version is unavailable, issue warning
  # and use earliest available version (to be safe)
  DEFAULT_GIT_VERSION=2.20.1
  ln -s $dir/git-completion.bash_v$DEFAULT_GIT_VERSION $dir/git-completion.bash
fi

# Detect tmux version number to load appropriate configuration file
TMUX_VERSION=$(tmux -V | cut -d' ' -f2 | cut -c1-1)
if [ -f $dir/tmux.conf_v$TMUX_VERSION ]; then
  ln -s $dir/tmux.conf_v$TMUX_VERSION $dir/tmux.conf
else
  DEFAULT_TMUX_VERSION=1.9
  ln -s $dir/tmux.conf_v$DEFAULT_TMUX_VERSION $dir/tmux.conf
fi

# move any existing configfiles in homedir to configfiles_old directory,
# then create symlinks from the homedir to any files in the ~/configfiles
# directory specified in $files
for file in $files; do
  echo "Moving any existing configfiles from ~ to $olddir"
  mv ~/.$file $olddir/.
  echo "Creating symlink to $file in home directory."
  ln -s $dir/$file ~/.$file
done

# Create empty _local files
touch ~/.vimrc_local
touch ~/.bashrc_local
