# A Dockerfile to provide an RPM build environment.

FROM centos:6

RUN yum -y localinstall http://mirror.rit.edu/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum -y update
RUN yum -y install @development mock sudo rpmdevtools
RUN sed -i 's/requiretty/!requiretty/' /etc/sudoers
RUN rpmdev-setuptree
RUN echo '%_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros

CMD /bin/bash --login
