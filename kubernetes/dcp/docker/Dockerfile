FROM centos:centos7.9.2009

RUN yum -y update && yum -y install sudo && yum -y install wget && yum -y install epel-release && yum -y install python-pip
RUN useradd -m unifi && echo "unifi:unifi" | chpasswd && usermod -aG root unifi
RUN echo "unifi ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

## Define working directory
COPY install.sh /home/unifi
RUN chown -R unifi /home/unifi

EXPOSE 8000 
EXPOSE 7199 
EXPOSE 9042 
EXPOSE 5432 
EXPOSE 8083
EXPOSE 6379

CMD ["/home/unifi/install.sh"]