
#rootpwd=screencastsafe
rootpwd=$(shell xxd -l 16 -p /dev/random)
imagename_build=holimg_build
imagename_dohub=andreaslindner/hol4docker
containername=holcontainer
#sharetarget=$(shell pwd)/share
sharetarget=$(HOME)
USERNAME=$(USER)

# 0 for ssh, 1 for direct x server
withxserver=1


emacs: emacs-w





build: Dockerfile
	docker build -t $(imagename_build) .
	#docker build -t $(imagename_build) -rm=true .
	echo $(imagename_build) > imagename


push_build:
	# push
	docker login
	docker tag $(imagename_build) andreaslindner/hol4docker
	docker push andreaslindner/hol4docker



pull:
	# pull
	docker pull $(imagename_dohub)
	echo $(imagename_dohub) > imagename
	




configure: configure_container.sh imagename
	rm -rf out
	mkdir out
	mkdir -p share
	./configure_container.sh $(rootpwd) $(shell cat imagename) $(containername) $(sharetarget) $(withxserver)
	touch configure




clean:
	rm -rf out
	rm -f configure
	docker container stop $(containername)
	docker container rm $(containername)



stop: configure
	docker container stop $(containername)

start: configure
	docker container start $(containername)




bash: start
	docker container exec -it -u lindnera $(containername) /bin/bash -c "sudo -u $(USERNAME) bash"

emacs-w: start
	docker container exec -it -u lindnera $(containername) /bin/bash -c "sudo -u $(USERNAME) emacs"

emacs-nw: start
	docker container exec -it -u lindnera $(containername) /bin/bash -c "sudo -u $(USERNAME) emacs -nw"

ssh: start
	ssh -X -p9922 $(USERNAME)@127.0.0.1
