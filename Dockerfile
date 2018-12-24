# glxgears
# ftp://www.x.org/pub/X11R6.8.1/doc/glxgears.1.html

# docker build -t glxgears .
# xhost +si:localuser:root
# docker run --runtime=nvidia -ti --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix glxgears

FROM nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04

ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},display

COPY meshmixer_*_amd64.deb /
COPY meshmixer-install.sh /

RUN apt-get update && apt-get install -y apt-utils && apt-get install -y --no-install-recommends \
        mesa-utils && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \ 
    apt-get -y install sudo vim rsync git curl

RUN apt-get install sudo && dpkg -i /meshmixer_*_amd64.deb || apt-get install -y -f

RUN apt-get install -y libqtcore4 libqtgui4 libqt4-opengl libqtwebkit4 libglu1-mesa liblapack3

# Replace 1000 with your user / group id
#RUN useradd -m developer && echo "developer:developer" | chpasswd && adduser developer sudo
RUN useradd -m developer && echo "developer:developer" | chpasswd && adduser developer sudo
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer/Documents && \
    mkdir -p /etc/sudoers.d && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

COPY entrypoint.sh /
RUN mkdir /opt && \
    chmod +x /meshmixer-install.sh && \
    chmod +x /entrypoint.sh
RUN /meshmixer-install.sh


USER developer
ENV HOME /home/developer
ENV QT_X11_NO_MITSHM 1

ENTRYPOINT ["/entrypoint.sh"]
#ENTRYPOINT [ "sh", "-c", "/entrypoint.sh" ]
#CMD /bin/bash
#CMD ["glxgears", "-info"]
#CMD ["bash", "-info"]
CMD ["import bunnyr.obj"]
