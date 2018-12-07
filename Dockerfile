#Download base image ubuntu 18.04
FROM ubuntu:18.04

################################
# UPDATE UBUNTU AND INSTAL USEFUL APPS AND UTILITIES
################################
RUN apt-get update -y \
    && apt-get install -y \
        wget \
        curl \
        vim

#################################
# INSTALL NGINX
#################################
RUN apt-get update \
    && apt-get install -y \
        nginx

RUN rm /etc/nginx/sites-enabled/default && rm /etc/nginx/sites-available/default
COPY ./.docker/nginx/default.conf /etc/nginx/sites-available/default
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

#################################
# INSTALL PHP-FPM
#################################
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata \
    && apt-get install -y \
        php-fpm

#################################
# SETUP CODE DIRECTORY
#################################
RUN mkdir -p /var/code/public \
    && mkdir -p /var/log

# Add code to image
COPY ./ /var/code

# Add entry/cmd script
COPY .docker/entry.sh /entry.sh

# Remove incompatible line breaks do to windows
RUN sed -i -e 's/\r$//' entry.sh

ENTRYPOINT ["/entry.sh"]
CMD ["/entry.sh"]
