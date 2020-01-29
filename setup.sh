#!/bin/bash

DIR_TMP="/srv/tmp/"
DIR_WWW=$1
DIR_GIT="/srv/git/"
# DIR_ENV="/srv/env/"
PROJECT_NAME=$2

# setup TMP stuff
sudo mkdir -p $DIR_TMP || echo "Make dir "$DIR_TMP" ERROR !"
sudo chgrp -R users $DIR_TMP || echo "Setup Group Perms Recursively "$DIR_TMP" ERROR !"
sudo chmod g+w $DIR_TMP || echo "Setup Perms "$DIR_TMP" ERROR !"
echo '[+] Setup TMP Success !'

# setup target deploy
sudo mkdir -p $DIR_WWW$PROJECT_NAME || echo "Make dir "$DIR_WWW" ERROR !"
sudo chgrp -R users $DIR_WWW$PROJECT_NAME || echo "Make dir "$DIR_WWW" ERROR !"
sudo chmod g+w $DIR_WWW$PROJECT_NAME || echo "Make dir "$DIR_WWW" ERROR !"
echo '[+] Setup Target Deploy Success !'

sudo mkdir -p $DIR_GIT$PROJECT_NAME.git || echo "Make dir "$DIR_GIT$PROJECT_NAME.git" ERROR !"

# Init the repo as an empty git repository
cd $DIR_GIT$PROJECT_NAME.git
sudo git init --bare || echo "Init git ERROR !"

cd $DIR_GIT$PROJECT_NAME.git

# Define group recursively to "users", on the directories
sudo chgrp -R users .
# Define permissions recursively, on the sub-directories 
# g = group, + add rights, r = read, w = write, X = directories only
# . = curent directory as a reference
sudo chmod -R g+rwX .

# Sets the setgid bit on all the directories
# https://www.gnu.org/software/coreutils/manual/html_node/Directory-Setuid-and-Setgid.html
sudo find . -type d -exec chmod g+s '{}' +


cd $DIR_GIT$PROJECT_NAME.git/hooks
sudo touch $DIR_GIT$PROJECT_NAME.git/hooks/post-receive

sudo bash -c 'cat << EOF > post-receive
#!/bin/sh
# The production directory
TARGET="'$DIR_WWW$PROJECT_NAME'"
# A temporary directory for deployment
TEMP="/srv/tmp/'$PROJECT_NAME'"
# The Git repo
REPO="/srv/git/'$PROJECT_NAME.git'"
# Deploy the content to the temporary directory
mkdir -p \$TEMP
git --work-tree=\$TEMP --git-dir=\$REPO checkout -f
cd \$TEMP
# Do stuffs, like npm install, composer update or generate .env file for Laravel
# Replace the production directory
# with the temporary directory
cd /
rm -rf \$TARGET
mv \$TEMP \$TARGET
EOF'

# make it executable 
sudo chmod +x post-receive

echo "[ ALL SETUP SUCCESSFULLY !]"

