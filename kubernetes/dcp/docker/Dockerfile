FROM centos:centos7

RUN yum -y update && yum -y install sudo \
 wget \
 epel-release \
 python-pip \
 tar

RUN yum -y install python3 \
  python3-pip \
  shadow-utils
  
RUN useradd -m unifi && echo "unifi:unifi" | chpasswd && usermod -aG root unifi
RUN echo "unifi ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

## Define working directory
COPY install.sh /home/unifi
RUN chown -R unifi /home/unifi

EXPOSE 8000

CMD ["/home/unifi/install.sh"]