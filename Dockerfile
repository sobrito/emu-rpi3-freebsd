FROM debian:9.2

RUN apt-get update
RUN apt-get install -y openssh-server qemu-system-arm sudo vim xz-utils telnet dos2unix wget
RUN apt-get clean

ENV REPO_PASSWD=Mudar123

RUN mkdir /workspace  \
     && mkdir -p /usr/src/aarch64

RUN wget http://releases.linaro.org/components/kernel/uefi-linaro/16.02/release/qemu64/QEMU_EFI.fd \
    && wget http://ftp.freebsd.org/pub/FreeBSD/releases/arm64/aarch64/ISO-IMAGES/12.0/FreeBSD-12.0-RC2-arm64-aarch64-RPI3.img.xz \
    && xz -d FreeBSD-12.0-RC2-arm64-aarch64-RPI3.img.xz \
    && mv FreeBSD-12.0-RC2-arm64-aarch64-RPI3.img rpi3.img

COPY ./tools/start-packages.sh /usr/local/bin/start-packages
RUN chmod +x  /usr/local/bin/start-packages \
    && dos2unix /usr/local/bin/start-packages

RUN useradd -ms /bin/bash repo && echo "repo:${REPO_PASSWD}" | chpasswd
RUN echo "repo ALL=(ALL:ALL) ALL" >> /etc/sudoers
RUN chown -R repo:repo /workspace

VOLUME [ "/workspace" ]

EXPOSE 22
EXPOSE 23

CMD ["start-packages"]
