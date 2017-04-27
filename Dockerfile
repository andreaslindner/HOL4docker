FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server inetutils-ping nano make

RUN apt-get update && apt-get install -y emacs polyml git build-essential g++ libpolyml-dev

RUN cd /opt && git clone git://github.com/HOL-Theorem-Prover/HOL.git && cd HOL && git checkout kananaskis-11

RUN cd /opt/HOL && echo "  val polymllibdir = \"/usr/lib/x86_64-linux-gnu\";" > tools-poly/poly-includes.ML && poly < tools/smart-configure.sml && bin/build



# for sshd
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile


RUN mkdir /root/out

#USER developer
#ENV HOME /home/developer

RUN apt-get update && apt-get install -y sudo
#ttf-ancient-fonts

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

