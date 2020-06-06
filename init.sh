#!/bin/zsh
DIR="$(readlink -f "$( cd "$( dirname "$0" )" && pwd )")"

echo "DIR: = "$DIR

# Allow the installation destination to be passed in as arg1
# otherwise, default to the current user's $HOME.
if (($+1)); then
  DESTINATION=$1
else
  DESTINATION=$HOME
fi

# Get the absolute location of $DESTINATION.
DESTINATION="$(readlink -f "$DESTINATION")"


for file in $(find $DIR/home -maxdepth 1); do
  file=${file#$DIR/home/}

  if [[ $file =~ '^[a-z]' ]]
  then
    echo "ln -s \e[1;34m$DIR/home\e[00m/$file \e[0;35m$DESTINATION\e[00m/.$file"
  fi

done
echo ""

for file in $(find $DIR/config -maxdepth 1); do
  file=${file#$DIR/config/}

  if [[ $file =~ '^[a-z]' ]]
  then
    echo "ln -s \e[1;34m$DIR/home\e[00m/$file \e[0;35m$DESTINATION/.config\e[00m/$file"
  fi
done
echo ""

echo -n "Does this look correct? (\e[1;32my\e[00m/\e[00;31mn\e[00m) "
read REPLY
if [[ $REPLY != "y" ]]; then
  echo "\e[00;31mExiting. Won't install your dotfiles bro.\e[00m"
  exit 1
fi

# Symlink the home files into the home directory.
for file in $(find $DIR/home -maxdepth 1); do
  file=${file#$DIR/home/}

  if [[ $file =~ '^[a-z]' ]]
  then

    # Does the file already exist?
    if [ -e "$DESTINATION/.$file" ] || [ -h "$DESTINATION/.$file" ]
    then
      # If it does exist, ask whether or not to overwrite it.
      echo -n ".$file exists. Overwrite? (\e[1;32my\e[00m/\e[00;331mn\e[00m) "
      read OVERWRITE
      # If overwrite has been confirmed, start removing the existing files.
      if [[ $OVERWRITE == 'y' ]]
      then
        if [[ -f "$DESTINATION/.$file" ]] || [[ -h "$DESTINATION/.$file" ]]
        then
          # Remove single files.
          rm "$DESTINATION/.$file"
        fi
        if [[ -d "$DESTINATION/.$file" ]]
        then
          # Remove directories.
          rm -r "$DESTINATION/.$file"
        fi
        echo "\e[1;32mLinking $file...\e[00m"
        ln -s $DIR/home/$file $DESTINATION/.$file
      # If overwrite has not been confirmed, skip the file.
      else
        echo "\e[1;31mSkipping file\e[00m"
        continue
      fi
    # If the file does not exist:
    else
      echo "\e[1;32mLinking $file...\e[00m"
      ln -s $DIR/home/$file $DESTINATION/.$file
    fi
  fi
done


# Symlink the config files into the home/.config directory.
for file in $(find $DIR/config -maxdepth 1); do
  file=${file#$DIR/config/}

  if [[ $file =~ '^[a-z]' ]]
  then

    # Does the file already exist?
    if [ -e "$DESTINATION/.config/$file" ] || [ -h "$DESTINATION/.config/$file" ]
    then
      # If it does exist, ask whether or not to overwrite it.
      echo -n ".$file exists. Overwrite? (\e[1;32my\e[00m/\e[00;331mn\e[00m) "
      read OVERWRITE
      # If overwrite has been confirmed, start removing the existing files.
      if [[ $OVERWRITE == 'y' ]]
      then
        if [[ -f "$DESTINATION/.config/$file" ]] || [[ -h "$DESTINATION/.config/$file" ]]
        then
          # Remove single files.
          rm "$DESTINATION/.config/$file"
        fi
        if [[ -d "$DESTINATION/.config/$file" ]]
        then
          # Remove directories.
          rm -r "$DESTINATION/.config/$file"
        fi
        echo "\e[1;32mLinking $file...\e[00m"
        ln -s $DIR/config/$file $DESTINATION/.config/$file
      # If overwrite has not been confirmed, skip the file.
      else
        echo "\e[1;31mSkipping file\e[00m"
        continue
      fi
    # If the file does not exist:
    else
      echo "\e[1;32mLinking $file...\e[00m"
      ln -s $DIR/config/$file $DESTINATION/.config/$file
    fi
  fi
done

echo "Creating subdirectories for vim..."
mkdir $DIR/home/vim/swaps; mkdir $DIR/home/vim/backups; mkdir $DIR/home/vim/undo;

echo "Grabbing submodules..."
git submodule init; git submodule update;

echo "All finished!"

