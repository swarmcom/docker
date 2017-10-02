FROM centos

USER root

COPY build/build.sh build/build.sh
COPY start.sh start.sh
RUN build/build.sh
EXPOSE 15060 8084 8184 8284 11000-12999

CMD ["./start.sh"]
