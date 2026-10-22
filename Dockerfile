ARG BASE_IMAGE=debian:bullseye
ARG TZ=America/New_York
FROM ${BASE_IMAGE}

RUN apt-get update && apt-get install -y --no-install-recommends git curl python3 python3-pip python3-dev build-essential sudo pkg-config ca-certificates locales tzdata golang fontconfig gcc cron ffmpeg && dpkg-reconfigure locales && apt-get clean

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN mkdir /etc/crontabs

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

RUN pip3 install scdl

RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]