
#rootpwd=screencastsafe
rootpwd=$(shell xxd -l 16 -p /dev/random)
imagename_build=holimg_build
imagename_dohub=andreaslindner/hol4docker
containername=holcontainer
#sharetarget=$(shell pwd)/share
#sharetarget=$(HOME)
sharetarget=/NOBACKUP/projects/holcourse
USERNAME=$(USER)

# 0 for ssh, 1 for direct x server
withxserver=1

# 0 in case your user is in the group docker (then you have sufficient privilegies to run docker commands), 1 otherwise
usesudo=0


ifeq ($(usesudo),0)
	dockerprefix=
else
	dockerprefix=sudo
endif

emacs: emacs-w





build: Dockerfile
	$(dockerprefix) docker build -t $(imagename_build) .
	#$(dockerprefix) docker build -t $(imagename_build) -rm=true .
	echo $(imagename_build) > imagename


push_build:
	# push
	$(dockerprefix) docker login
	$(dockerprefix) docker tag $(imagename_build) andreaslindner/hol4docker
	$(dockerprefix) docker push andreaslindner/hol4docker



pull:
	# pull
	$(dockerprefix) docker pull $(imagename_dohub)
	echo $(imagename_dohub) > imagename





configure: configure_container.sh configure_container_script imagename
	rm -rf out
	mkdir out
	mkdir -p share
	./configure_container.sh $(rootpwd) $(shell cat imagename) $(containername) $(sharetarget) $(withxserver) "$(dockerprefix)"
	touch configure




clean:
	rm -rf out
	rm -f configure
	$(dockerprefix) docker container stop $(containername)
	$(dockerprefix) docker container rm $(containername)



stop: configure
	$(dockerprefix) docker container stop $(containername)

start: configure
	$(dockerprefix) docker container start $(containername)




bash: start
	$(dockerprefix) docker container exec -it -u $(USERNAME) $(containername) /bin/bash -c "sudo -u $(USERNAME) bash"

emacs-w: start
	$(dockerprefix) docker container exec -it -u $(USERNAME) $(containername) /bin/bash -c "sudo -u $(USERNAME) emacs"

emacs-nw: start
	$(dockerprefix) docker container exec -it -u $(USERNAME) $(containername) /bin/bash -c "sudo -u $(USERNAME) emacs -nw"

ssh: start
	ssh -X -p9922 $(USERNAME)@127.0.0.1
