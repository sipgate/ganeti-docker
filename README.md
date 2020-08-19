# A docker container running a ganeti virtual/fake cluster

This is a debian 10 container running a virtual ganeti cluster.
You can expose the RAPI on Port 5080 to interact with the cluster.

## Install
You can use docker packages to pull the image or build it yourself.

## Howto build

```
sudo docker build .
```

## Howto run

```
[sudo] docker run -d -p 5080:5080 --cap-add=NET_ADMIN $docker_image_id
```
