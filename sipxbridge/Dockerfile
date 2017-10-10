FROM ezuce/sipxrelay

RUN rm -rf /usr/local/sipxrelay.sh
RUN mkdir -p usr/local/sipx/var/log/sipxpbx/
COPY conf/sipxbridge.sh /usr/local


CMD /usr/local/sipxbridge.sh 
