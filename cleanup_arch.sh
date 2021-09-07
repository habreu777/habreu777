#! /bin/sh
read -p "Warning! you may loose dada. Continue (y/n)?" CONT
if [ "$CONT" = "y" ]; then

  sudo pacman -S rmlint
  sudo pacman -Rns $(pacman -Qtdq)
  rm -rf ~/.cache/*
  rmlint /home/hector
  sudo pacman -S ncdu
  sh ./rmlint.sh
  ncdu
else
  echo "Operation aborted";
fi





