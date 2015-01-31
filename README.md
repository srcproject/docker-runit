[Strathclyde Relay Chat (src)][src] - runit
===========================================

[src]: https://github.com/srcproject


Dependencies
------------

This image is built uppon a minimal Debian installation. Please, [do not trust
Docker's "(Semi) Official Debian base image"][official-image] and build it
yourself by running:

    ../mkimage.sh -t srcproject/debian:stable debootstrap --variant-minbase stable

More info at [Debian's wiki][debian-docker]

[official-image]: https://joeyh.name/blog/entry/docker_run_debian/
[debian-docker]: https://wiki.debian.org/Cloud/CreateDockerImage

Giving ourselfs access
----------------------

Just replace the contents of `authorized_keys` with whatever keys you want to
give access.

Adding a service
----------------

To add a service simply create a directory inside `/etc/service/` with a `run`
file with execution permissions and put whatever you want to execute inside it:

    RUN mkdir /etc/service/unrealircd && echo '#!/bin/sh\n\
    exec /usr/bin/unrealircd -F' > /etc/service/unrealircd/run
    RUN chown root.root /etc/service/unrealircd/run
    RUN chmod 750 /etc/service/unrealircd/run

Running the image
-----------------

    sudo docker run -d -p 1122:22 srcproject/runit

    # We can then access it through
    ssh -p 1122 root@localhost
