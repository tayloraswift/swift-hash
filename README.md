<div align="center">

***`hash`***<br>`0.6`

[![ci status](https://github.com/tayloraswift/swift-hash/actions/workflows/ci.yml/badge.svg)](https://github.com/tayloraswift/swift-hash/actions/workflows/ci.yml)
[![swift package index versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Ftayloraswift%2Fswift-hash%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/tayloraswift/swift-hash)
[![swift package index platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Ftayloraswift%2Fswift-hash%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/tayloraswift/swift-hash)

</div>

*`swift-hash`* is an inline-only microframework providing generic, pure-Swift implementations of various hashes, checksums, and binary utilities.

<div align="center">

[documentation and api reference](https://swiftinit.org/docs/swift-hash)

</div>


## products

This package vends the following library products:

1.  [`Base16`](https://swiftinit.org/docs/swift-hash/base16)

    Tools for encoding to and decoding from base-16 strings.

1.  [`Base64`](https://swiftinit.org/docs/swift-hash/base64)

    Tools for encoding to and decoding from base-64 strings.

1.  [`CRC`](https://swiftinit.org/docs/swift-hash/crc)

    Implements [CRC-32](https://en.wikipedia.org/wiki/Cyclic_redundancy_check) checksums.

1.  [`MD5`](https://swiftinit.org/docs/swift-hash/md5)

    Implements [MD5](https://en.wikipedia.org/wiki/MD5) hashing function.

1.  [`MessageAuthentication`](Sources/MessageAuthentication)

    Implements [hash-based message authentication codes](https://en.wikipedia.org/wiki/HMAC) (HMACs) through protocols that types in the other modules conform to.

1.  [`SHA1`](https://swiftinit.org/docs/swift-hash/sha1)

    Unimplemented: [SHA-1](https://en.wikipedia.org/wiki/SHA-1) hashing function.

1.  [`SHA2`](https://swiftinit.org/docs/swift-hash/sha2)

    Implements the [SHA-256](https://en.wikipedia.org/wiki/SHA-2) hashing function.
