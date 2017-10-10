FROM ezuce/sipxrelay

RUN rm -rf /usr/local/sipxrelay.sh
COPY conf/sipxbridge.sh /usr/local


CMD /usr/local/sipxbridge.sh 2>&1 | tee -a /var/log/sipx/sipxbridge.log
