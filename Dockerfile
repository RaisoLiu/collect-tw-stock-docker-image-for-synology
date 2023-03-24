FROM ubuntu:focal

LABEL maintainer="RaisoLiu <raisoliu@gmail.com>"

ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="100"

# Install necessary library
USER root

RUN apt-get update --yes && \
	apt-get upgrade --yes && \
	apt-get --yes install curl cron && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \

ENV SHELL=/bin/bash \
    NB_USER="${NB_USER}" \
    NB_UID=${NB_UID} \
    NB_GID=${NB_GID} \
	HOME="/home/${NB_USER}"

# Import script
COPY fix-permissions /usr/local/bin/fix-permissions
RUN chmod a+rx /usr/local/bin/fix-permissions
COPY start.sh /usr/local/bin/
RUN chmod a+rx /usr/local/bin/start.sh

# Run Cron job with non-root account
RUN useradd -l -m -s /bin/bash -N -u "${NB_UID}" "${NB_USER}" && \
    fix-permissions "${HOME}"

USER ${NB_UID}
RUN mkdir "/home/${NB_USER}/work" && \
    fix-permissions "/home/${NB_USER}"

RUN crontab -l | { cat; echo "30 11 * * 1-5 start.sh"; } | crontab -
CMD cron
