# Containerize

The Containerize app was built to assist in administrating a Docker Cluster.

Once connected to a cluster, the user can view the last state of the cluster in terms of running machines, installed images, configured volumes, and system information. The data can also be refreshed using a small refresh button in the corner.

The Docker Server instance must be configured to work with HTTP to work with this out of the box. HTTPS is not supported as Docker requires signed SSL certificates for authentication on the client as well, and that would complexify the user experience. That said, the Docker daemons endpoint should be secured through the use of a VPN or similar to prevent unauthorized access.

### Install
To install Docker, follow the link at 
https://docs.docker.com/engine/installation/.
### Configure - Runtime
To configure the Docker Daemon, add
`-H tcp://0.0.0.0:2376`
to the list of runtime arguments for the Docker daemon.

Ex. `docker daemon -H tcp://0.0.0.0:2376`

This lets Docker communicate with the iOS app through HTTP.

#### Daemonization:
The technicality behind daemonization differs by operating system, but the same concept applies as the aforementioned argument should be added. 
#####
In Ubuntu this would involve adding the line `DOCKER_OPTS='-H tcp://0.0.0.0:2376'` to the `/etc/default/docker` file. Then the daemon should be restarted using the command `service docker restart`.
