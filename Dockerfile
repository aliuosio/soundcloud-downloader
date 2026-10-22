FROM debian:bullseye

RUN apt-get update && apt-get install -y --no-install-recommends git curl python3 python3-pip python3-dev build-essential sudo pkg-config ca-certificates locales tzdata golang fontconfig gcc cron ffmpeg && dpkg-reconfigure locales && apt-get clean

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN mkdir -p /Music/SoundCloud/krusty/ONE

RUN mkdir /etc/crontabs

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

RUN pip3 install scdl

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN scdl --version

RUN echo '0 0 * * * scdl -f -c --original-art --original-name --original-metadata --name-format "{artist} - {title}" -l https://soundcloud.com/krusty --path /Music/SoundCloud/krusty/ONE --debug' > /crontab.txt && crontab /crontab.txt && rm /crontab.txt

CMD ["sh", "-c", "echo 'Starting downloads...' && scdl -f -c --original-art --original-name --original-metadata --name-format '{artist} - {title}' -l https://soundcloud.com/krusty --path /Music/SoundCloud/krusty/ONE && echo 'ONE done. Starting cron...' && cron -f"]