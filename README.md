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
podman run --rm -it -p8989:8989 smolservice
```

Connect a client:
```
telnet localhost 8989
```

## Next steps

`polybuild` was created to support the recursive MLB setups created by
`smlpkg`, use [sml-server] via [smlpkg] for a more complete example.

Problems:
* Alpine linux only seems to have polyml, no mlton or mlkit
* cmdargs.sml seems incompatible with Poly/ML (argv is evaluated at build time)
* http-server crashes with `Run out of store - interrupting threads` if built with Poly/ML

[sml-server]: https://github.com/diku-dk/sml-server
[smlpkg]: https://github.com/diku-dk/smlpkg
