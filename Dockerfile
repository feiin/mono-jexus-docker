FROM centos:latest
MAINTAINER feiin(http://github.com/feiin)

RUN rpm --import "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF" && \
    yum-config-manager --add-repo http://download.mono-project.com/repo/centos/ 

RUN yum -y install mono-complete

ENV JEXUS_VERSION 5.8.1

RUN curl -O http://www.linuxdot.net/down/jexus-$JEXUS_VERSION.tar.gz && \
    tar -zxvf jexus-$JEXUS_VERSION.tar.gz && \
    cd jexus-$JEXUS_VERSION && \
    ./install 
    
RUN yum -y install openssh-server

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -C '' -N '' && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -C '' -N ''  && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -C '' -N ''

RUN mkdir /www && touch /start.sh && chmod 777 /start.sh

RUN echo '#!/bin/bash' > /start.sh && \
    echo '# /usr/jexus/jws start' >> /start.sh && \
    echo '/usr/sbin/sshd -D' >> /start.sh

CMD ["/bin/bash", "/start.sh"]
