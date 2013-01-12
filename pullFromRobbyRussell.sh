#!/bin/zsh

echo "Pull changes from Robby Russel's repository"
echo "###########################################"
echo ""
git pull git@github.com:robbyrussell/oh-my-zsh.git

echo ""

echo "Push changes to own repository"
echo "##############################"
echo ""
git push
