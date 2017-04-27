# HOL4docker
A docker image containing HOL4 and Emacs.

This project belongs to the Docker Hub repository https://hub.docker.com/r/andreaslindner/hol4docker/.

# Quickstart
Just pull this repository and from there execute:
1. ``make pull`` - downloads the
2. ``make`` - configures and then runs emacs
3. (For installing the sml-mode for emacs, refer to Installation step 3 below.)

# Usage
You can control the container and connect to it using the following make build targets. By default the home folder is mapped in the container as ``/home/{user}/share`` and files can be accessed there. In some networked configurations that might not work because of the security context in which docker runs its containers. Then please refer to the last section.

1. ``make stop`` and ``make start`` to stop and run the container respectively.
2. ``make bash``, ``make ssh``, ``make emacs`` and ``make emacs-nw`` to connect to the container. (For the targets ssh and emacs together with XServer, see the section below.)

# Installation step-by-step
1. ``make pull`` or ``make build`` to pull a prebuilt image or compile an image respectively.
2. ``make configure`` to create a container and initialize it for the currently logged on user. (See the first lines of `Makefile` for conifguration options.)
3. Start emacs in the container and then type `>M-x< package-install >RET< sml-mode >RET<` to install the sml-mode for emacs.
4. (``make clean`` to clean a configuration and remove the container in case it exists.)

# Configuration and options
* ``sharetarget`` in ``Makefile``, set it to the folder you want to be mapped in the containers ``/home/{user}/share``.
* ``withxserver`` in ``Makefile``, set it to 1 or 0 whether you plan to use emacs directly or over ssh.
