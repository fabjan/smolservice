# smolservice

Smolservice is a small program demonstrating how to build a network server
using Standard ML.

## Requirements

* [Poly/ML] or [MLton]

[Poly/ML]: https://www.polyml.org
[MLton]: http://mlton.org

## Building

A local build:
```
./build.sh
```

Build a container image:
```
podman build . -t smolservice
```

## Running

A local build:
```
_build/smolservice
```

A container:
```
podman run --rm -it -p3000:3000 smolservice
```

Connect a client:
```
curl http://localhost:3000
```
