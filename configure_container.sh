#!/bin/bash



USERNAME=$USER
ROOTPWD=$1
DOCKERIMAGE=$2
DOCKERCONTAINER=$3
SHARETARGET=$4
WITHXSERVER=$5
DOCKERPREFIX=$6


# stop and remove container (just in case it exists)
$DOCKERPREFIX docker container stop $DOCKERCONTAINER
$DOCKERPREFIX docker container rm $DOCKERCONTAINER

# create container from image
if [ $WITHXSERVER != "0" ]
then
	XSERVERMAPPINGS="-e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/.Xauthority:/home/$USERNAME/.Xauthority"
fi

$DOCKERPREFIX docker container create -p 127.0.0.1:9922:22 -v $(pwd)/out:/root/share-out -v $SHARETARGET:/home/$USERNAME/share -w /home/$USERNAME $XSERVERMAPPINGS --pid=host --ipc=host --name $DOCKERCONTAINER $DOCKERIMAGE

$DOCKERPREFIX docker container start $DOCKERCONTAINER





# configure everything in the container
USRID=$(id -u $USERNAME)
GRPID=$(id -g $USERNAME)
cat configure_container_script \
	| sed -e "s/__ROOTPWD/$ROOTPWD/g" - \
	| sed -e "s/__USERNAME/$USERNAME/g" - \
	| sed -e "s/__USRID/$USRID/g" - \
	| sed -e "s/__GRPID/$GRPID/g" - \
	> out/configure_docker.sh

chmod +x out/configure_docker.sh


# ssh-keygen -t rsa -b 4096
file_name=$HOME/.ssh/id_rsa.pub
if [ -f "$file_name" ]
then
	cat $file_name > out/${USERNAME}_id_rsa.pub
fi




$DOCKERPREFIX docker container exec -ti $DOCKERCONTAINER /bin/bash /root/share-out/configure_docker.sh


















