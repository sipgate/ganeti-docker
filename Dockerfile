FROM debian:12

RUN apt update && apt install --no-install-recommends -y ganeti ganeti-os-noop net-tools python-is-python3 && apt clean

ADD entrypoint.sh /entrypoint.sh
ADD start-gnt-rapi.sh /start-gnt-rapi.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/start-gnt-rapi.sh"]
