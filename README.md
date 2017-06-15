eZuce containers
Init

You need to have Docker version at least 1.9.0 (as this setup relies on docker network heavily) and git installed

git clone https://github.com/swarmcom/docker-init.git

next run

./install.sh

You can also build each docker image alone from the correct folder with ./build.sh or start it with ./run.sh
Building docker images

Each docker image can be build by running ./build.sh under each folder.

    Note : there are some images like (mongo) where you only need to run them since those are maintained in dockerhub official repository by the creators of those projects

Structure of each folder used to build images
```
- parent_folder (sipxproxy as an example)
  -- build
     ---  scripts used for docker image build
  -- conf 
     --- scripts and placehoders used to be imported during  docker container run
  -- etc
     --- storing the rpm repository used for yum installs
  -- src
     --- in this folder the source code will be downloaded from sipxcom repository.At the time of this instruction we are using branch release-17.08
  -- Dokcerfile     used to create docker image   
  -- build.sh       used to build docker image based on Dockerfile
  -- run.sh         used to start a container independently (you can also use .install.sh from swarmcom/docker-init)
     
```
As a developer your time will be mainly spent under build folder and on the main sipxcom repository where you will commit changes to the code from which docker images are build

Automatic build notes under travis branch
=====


