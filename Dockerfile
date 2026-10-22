ARG BASE_IMAGE=python:3.12-slim
ARG TZ=America/New_York
FROM ${BASE_IMAGE}

# ponytail: scdl is pure Python; only ffmpeg (audio conversion) and cron are needed at runtime.
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg cron tzdata \
 && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir scdl

RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
