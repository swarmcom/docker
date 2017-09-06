FROM docker:latest
RUN apk update && apk upgrade && apk add bash && apk add sudo
COPY watcher.sh /usr/bin/watcher.sh
COPY file-watcher.sh /usr/bin/file-watcher.sh
COPY newcidr.sh /usr/bin/newcidr.sh
COPY checkip.sh /usr/bin/checkip.sh
COPY process-watcher.sh /usr/bin/process-watcher.sh
COPY dns-config.sh /usr/bin/dns-config.sh
ENTRYPOINT ["/usr/bin/watcher.sh"]
