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
