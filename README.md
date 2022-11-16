<div align="center">
  
***`hash`***<br>`0.4.1`
  
[![ci status](https://github.com/kelvin13/swift-hash/actions/workflows/build.yml/badge.svg)](https://github.com/kelvin13/swift-hash/actions/workflows/build.yml)
[![ci status](https://github.com/kelvin13/swift-hash/actions/workflows/build-devices.yml/badge.svg)](https://github.com/kelvin13/swift-hash/actions/workflows/build-devices.yml)
[![ci status](https://github.com/kelvin13/swift-hash/actions/workflows/build-windows.yml/badge.svg)](https://github.com/kelvin13/swift-hash/actions/workflows/build-windows.yml)


[![swift package index versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkelvin13%2Fswift-hash%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/kelvin13/swift-hash)
[![swift package index platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkelvin13%2Fswift-hash%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/kelvin13/swift-hash)

</div>

*`swift-hash`* is an inline-only microframework providing generic, pure-Swift implementations of various hashes, checksums, and binary utilities.

## products

The package vends the following library products:

1.  [`Base16`](Sources/Base16)

    Tools for encoding to and decoding from base-16 strings.

1.  [`Base64`](Sources/Base64)

    Tools for encoding to and decoding from base-64 strings.

1.  [`CRC`](Sources/CRC)

    Implements [CRC-32](https://en.wikipedia.org/wiki/Cyclic_redundancy_check) checksums.

1.  [`MessageAuthentication`](Sources/MessageAuthentication)

    Implements [hash-based message authentication codes](https://en.wikipedia.org/wiki/HMAC) (HMACs) through protocols that types in the other modules conform to.

1.  [`SHA2`](Sources/SHA2)

    Implements the [SHA-256](https://en.wikipedia.org/wiki/SHA-2) hashing function.