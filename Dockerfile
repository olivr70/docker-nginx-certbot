FROM phusion/baseimage 
	# A minimal Ubuntu base image modified for Docker-friendliness
	# https://github.com/phusion/baseimage-docker

# create
#UID for "nginx" user
ARG UID=743
#uid for "logger" user
ARG UID_LOG=1743 


RUN echo $(tput smso) user 'nginx' $(id -u nginx) $(tput emso)

# add a 'nginx' user, which will run the nginx server
RUN addgroup --system --gid ${UID} nginx && \ 
adduser --system --disabled-login --gecos "nginx user" --uid ${UID} --gid ${UID} nginx
# add a 'logger' user, which run the loggers
RUN adduser --system --disabled-login --gecos "logging user" -uid ${UID_LOG} logger


# Add nginx (see https://nginx.org/en/linux_packages.html#Ubuntu) 
RUN apt-get update
RUN apt-get install curl gnupg2 ca-certificates lsb-release --yes
RUN echo "deb http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list
RUN curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
RUN apt-key fingerprint ABF5BD827BD9BF62

# add certbot (see https://certbot.eff.org/lets-encrypt/ubuntubionic-nginx)
RUN apt-get install -y software-properties-common && \
  add-apt-repository -y universe && \
  add-apt-repository -y ppa:certbot/certbot && \
  apt-get update && \
  apt-get install -y certbot

# install nginx
RUN apt-get install nginx --yes

RUN apt-get install -y python-certbot-nginx

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# ----------------------------------------------------------------------

LABEL version=0.0.1
LABEL description="An NGINX server with a certbot daemon with automatic certificat renewal"
LABEL maintainer="Olivier CHEVET <o.chevet@outlook.com>"

  
RUN echo user 'nginx' $(id -u nginx)

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN echo user 'nginx' $(id -u nginx)


# RUN nginx --version


EXPOSE 80/tcp 443/tcp

STOPSIGNAL SIGTERM

# copy startup scripts
RUN mkdir -p /etc/my_init_d
ADD --chown=nginx my_init.d /etc/my_init.d
# copy services, which will run by runsv
ADD --chown=nginx service /etc/service
#RUN chmod +x /etc/service/nginx/*.sh

