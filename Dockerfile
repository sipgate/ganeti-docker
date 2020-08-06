FROM debian:10

# LABEL version="0.1"
# LABEL "com.github.actions.name"="Flatpak Builder"
# LABEL "com.github.actions.description"="Build your flatpak project"
# LABEL "com.github.actions.icon"="package"
# LABEL "com.github.actions.color"="blue"

# LABEL "repository"="https://github.com/bilelmoussaoui/flatpak-github-actions"
# LABEL "homepage"="https://github.com/bilelmoussaoui/flatpak-github-actions"
# LABEL "maintainer"="Bilal Elmoussaoui<bil.elmoussaoui@gmail.com>"

# Setup Flatpak
RUN apt update
RUN apt install -y ganeti ganeti-os-noop net-tools
RUN apt clean

ADD entrypoint.sh /entrypoint.sh
ADD start-gnt-rapi.sh /start-gnt-rapi.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/start-gnt-rapi.sh"]
