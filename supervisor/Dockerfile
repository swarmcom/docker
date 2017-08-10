FROM docker:latest
RUN apk update && apk upgrade && apk add bash
COPY watcher.sh /usr/bin/watcher.sh
COPY file-watcher.sh /usr/bin/file-watcher.sh
COPY process-watcher.sh /usr/bin/process-watcher.sh
ENTRYPOINT ["/usr/bin/watcher.sh"]
