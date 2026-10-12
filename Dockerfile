FROM ubuntu:latest

LABEL org.opencontainers.image.authors="tigerblue77"

RUN apt-get update

RUN apt-get install ipmitool -y

ADD functions.sh /app/functions.sh
ADD constants.sh /app/constants.sh
ADD configuration.sh /app/configuration.sh
ADD healthcheck.sh /app/healthcheck.sh
ADD Dell_iDRAC_fan_controller.sh /app/Dell_iDRAC_fan_controller.sh

RUN chmod 0777 /app/functions.sh /app/constants.sh /app/configuration.sh /app/healthcheck.sh /app/Dell_iDRAC_fan_controller.sh

WORKDIR /app

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "/app/healthcheck.sh" ]

# Runtime defaults are applied by configuration.sh. Keeping configurable values
# out of the image metadata ensures explicit Docker/Compose/Unraid environment
# values remain authoritative and lets the controller report when defaults are used.

ENTRYPOINT ["./Dell_iDRAC_fan_controller.sh"]
