FROM boomi/install:3.2.8

## Create temp directories
RUN mkdir -p /home/boomi/gateway/local
RUN mkdir -p /home/boomi/gateway/temp

## Define working directory
RUN useradd -ms /bin/bash boomi
COPY install.sh /home/boomi
USER root
RUN chown -R boomi /home/boomi
USER boomi

ENV EXTRA_OPTIONS="--build-number-file=bin/build.number --user-lib-dir=userlib"
ENV AMC="Gateway"

EXPOSE 8077 18077

CMD ["/home/boomi/install.sh"]