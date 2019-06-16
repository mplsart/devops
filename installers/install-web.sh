#!/bin/bash
###################################################################################################
# Initial Installation Script for MPLSART web client
#
# To use this, download this file and place in the root of your primary
# projects root (eg. ~/workspaces/mplsart), then run ./installers/install-web.sh
#
# This will:
#   * Create a dir called ./web which will be the workspace
#   * Add a package.json for the workspace
#   * Check out the master branch of repositories for the "packages" for web and armature (this could be manually done)
#   * yarn installs all dependencies for both packages
#   * Finally it links armature into web - this step is still required because yarn can't get version of git url
##################################################################################################
echo "Greetings. Let's do stuff."

WORKSPACE_DIR="./web" # TODO: Promot for this? Detect collisions?


# Step 0: Ensure pre-requisites are installed
YARN_VERSION=$(yarn --version)
if [ -z "$YARN_VERSION" ]
then
  echo "ERR: yarn does not appear to be installed. Install using: brew install yarn"
  exit 0
else
  echo "Using $YARN_VERSION of yarn."
fi

# Step 1: Create web workspace dir
rm -rf ${WORKSPACE_DIR}
mkdir ${WORKSPACE_DIR}


# Step 2: Create a package.json for the workspace
touch ./${WORKSPACE_DIR}/package.json

/bin/cat <<EOM >${WORKSPACE_DIR}/package.json
{
  "private": true,
  "workspaces": [
    "web",
    "armature"
  ],
  "dependencies": {
    "express": "^4.17.1"
  }
}
EOM

# Step 3: Checkout repositories
rm -rf ${WORKSPACE_DIR}/web
rm -rf ${WORKSPACE_DIR}/armature

cd ${WORKSPACE_DIR}
git clone https://github.com/mplsart/web.git ./web
git clone https://github.com/mplsart/armature-v2.git ./armature


# Step 4: Yarn install
yarn install

# Step 5: Locally Link armature to trip up yarn comparing github url...
cd ./armature
pwd
yarn unlink #remove any existing links
yarn link


cd ../web
pwd
yarn link armature

# Step 6: show they're linked... should only be one armature in output
yarn list armature

echo "Success?? cd into web and run yarn run dev and in a separate console cd into armature and run yarn run dev-watch and make changes and see them magically update..."
