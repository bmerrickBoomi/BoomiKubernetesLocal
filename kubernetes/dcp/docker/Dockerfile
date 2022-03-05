FROM amazonlinux:2

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

EXPOSE 5432
EXPOSE 6379
EXPOSE 7199
EXPOSE 8000  
EXPOSE 8081
EXPOSE 8082
EXPOSE 8083
EXPOSE 8084
EXPOSE 8444
EXPOSE 8445
EXPOSE 8998
EXPOSE 9042
EXPOSE 9081  
EXPOSE 9082
EXPOSE 9083
EXPOSE 9084

CMD ["/home/unifi/install.sh"]