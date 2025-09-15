# Hello, Ice

This repository contains the source code for the Ice Hello server, `tcp -h hello.zeroc.com -p 4061`, a publicly available
[Ice](https://github.com/zeroc-ice/ice) server intended for the testing and development of Ice clients.

## Available Services

The following are available:

| Service                          | Identity  | Description                            | Example Clients                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| -------------------------------- | --------- | -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [greeter](./slice/Greeter.slice) | `greeter` | A simple service that greets visitors. | [C++](https://github.com/zeroc-ice/ice-demos/tree/main/cpp/Ice/greeter), [C#](https://github.com/zeroc-ice/ice-demos/tree/main/csharp/Ice/Greeter), [Java](https://github.com/zeroc-ice/ice-demos/tree/main/java/Ice/greeter), [JavaScript](https://github.com/zeroc-ice/ice-demos/tree/main/js/Ice/greeter), [MATLAB](https://github.com/zeroc-ice/ice-demos/tree/main/matlab/Ice/greeter), [PHP](https://github.com/zeroc-ice/ice-demos/tree/main/php/Ice/greeter), [Python](https://github.com/zeroc-ice/ice-demos/tree/main/python/Ice/greeter),  [Ruby](https://github.com/zeroc-ice/ice-demos/tree/main/ruby/Ice/greeter), [Swift](https://github.com/zeroc-ice/ice-demos/tree/main/swift/Ice/greeter) |

## Running the server using Docker

<!-- The `hello` server is available as a Docker image on [Docker Hub](https://hub.docker.com/r/icerpc/hello). The server
requires TLS certificates to run, so you will need to provide the server certificate and private key. This repository
contains a set of self-signed [certificates](./certs) that can be used for testing purposes. -->

### Docker CLI

```bash
docker run --name hello -p 4061:4061/tcp  zeroc/hello
```

Optional environment variables can be used to configure the server:

```bash
docker run \
  --name hello \
  -p 4061:4061/tcp  \
  zeroc/hello
```

### Docker Compose

```yml
services:
  hello:
    image: zeroc/hello
    ports:
      - "4061:4061"

```

## Building with Docker Compose

This repository contains a [`Dockerfile`](./Dockerfile) that can be used to build the server as well as a
[`compose.yaml`](./compose.yaml) file that can be used to build and run the server locally
using Docker Compose.

*The following commands must be run from the root directory of the repository.*

```bash
# Start the server (builds the server if it does not exist)
docker compose up

# Rebuild the server
docker compose build
```

Once running, the server will be available at the `tcp -h localhost -p 4061` endpoint.

Please refer to the [Docker Compose documentation](https://docs.docker.com/compose/) for more information on how to
use Docker Compose.
