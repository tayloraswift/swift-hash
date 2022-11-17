import Testing

@main
enum Main:SynchronousTests
{
    static
    func run(tests:inout Tests)
    {
        // https://datatracker.ietf.org/doc/html/rfc4231
        tests.group("hmac-sha-256")
        {
            $0.test(name: "1",
                key: 
                """
                0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b
                0b0b0b0b
                """,
                message: "4869205468657265",
                hmac256: 
                """
                b0344c61d8db38535ca8afceaf0bf12b
                881dc200c9833da726e9376c2e32cff7
                """
            )

            $0.test(name: "2",
                key: "4a656665",
                message: 
                """
                7768617420646f2079612077616e7420
                666f72206e6f7468696e673f
                """,
                hmac256: 
                """
                5bdcc146bf60754e6a042426089575c7
                5a003f089d2739839dec58b964ec3843
                """
            )

            $0.test(name: "3",
                key: 
                """
                aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                aaaaaaaa
                """,
                message: 
                """
                dddddddddddddddddddddddddddddddd
                dddddddddddddddddddddddddddddddd
                dddddddddddddddddddddddddddddddd
                dddd
                """,
                hmac256:
                """
                773ea91e36800e46854db8ebd09181a7
                2959098b3ef8c122d9635514ced565fe
                """
            )

            $0.test(name: "4",
                key: 
                """
                0102030405060708090a0b0c0d0e0f10
                111213141516171819
                """,
                message:
                """
                cdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcd
                cdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcd
                cdcdcdcdcdcdcdcdcdcdcdcdcdcdcdcd
                cdcd
                """,
                hmac256:
                """
                82558a389a443c0ea4cc819899f2083a
                85f0faa3e578f8077a2e3ff46729665b
                """
            )

            $0.test(name: "5",
                key: 
                """
                0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c
                0c0c0c0c
                """,
                message:
                """
                546573742057697468205472756e6361
                74696f6e
                """,
                hmac256:
                """
                a3b6167473100ee06e0c796c2955552b
                fa6f7c0a6a8aef8b93f860aab0cd20c5
                """
            )

            $0.test(name: "6",
                key: 
                """
                aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                aaaaaa
                """,
                message:
                """
                54657374205573696e67204c61726765
                72205468616e20426c6f636b2d53697a
                65204b6579202d2048617368204b6579
                204669727374
                """,
                hmac256:
                """
                60e431591ee0b67f0d8a26aacbf5b77f
                8e0bc6213728c5140546040f0ee37f54
                """
            )

            $0.test(name: "7",
                key: 
                """
                aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                aaaaaa
                """,
                message:
                """
                54686973206973206120746573742075
                73696e672061206c6172676572207468
                616e20626c6f636b2d73697a65206b65
                7920616e642061206c61726765722074
                68616e20626c6f636b2d73697a652064
                6174612e20546865206b6579206e6565
                647320746f2062652068617368656420
                6265666f7265206265696e6720757365
                642062792074686520484d414320616c
                676f726974686d2e
                """,
                hmac256:
                """
                9b09ffa71b942fcb27635fbcd5b0e944
                bfdc63644f0713938a7f51535c3a35e2
                """
            )
        }

        // https://stackoverflow.com/questions/5130513/pbkdf2-hmac-sha2-test-vectors
        tests.group("pbkdf2-hmac-sha-256")
        {
            $0.test(name: "single-iteration", 
                password: "password", salt: "salt", iterations: 1,
                derived:
                [
                    0x12, 0x0f, 0xb6, 0xcf, 0xfc, 0xf8, 0xb3, 0x2c,
                    0x43, 0xe7, 0x22, 0x52, 0x56, 0xc4, 0xf8, 0x37,
                    0xa8, 0x65, 0x48, 0xc9, 0x2c, 0xcc, 0x35, 0x48,
                    0x08, 0x05, 0x98, 0x7c, 0xb7, 0x0b, 0xe1, 0x7b,
                ])
            
            $0.test(name: "multiple-iterations",
                password: "password", salt: "salt", iterations: 2,
                derived:
                [
                    0xae, 0x4d, 0x0c, 0x95, 0xaf, 0x6b, 0x46, 0xd3,
                    0x2d, 0x0a, 0xdf, 0xf9, 0x28, 0xf0, 0x6d, 0xd0,
                    0x2a, 0x30, 0x3f, 0x8e, 0xf3, 0xc2, 0x51, 0xdf,
                    0xd6, 0xe2, 0xd8, 0x5a, 0x95, 0x47, 0x4c, 0x43,
                ])
            
            $0.test(name: "many-iterations",
                password: "password", salt: "salt", iterations: 4096,
                derived:
                [
                    0xc5, 0xe4, 0x78, 0xd5, 0x92, 0x88, 0xc8, 0x41,
                    0xaa, 0x53, 0x0d, 0xb6, 0x84, 0x5c, 0x4c, 0x8d,
                    0x96, 0x28, 0x93, 0xa0, 0x01, 0xce, 0x4e, 0x11,
                    0xa4, 0x96, 0x38, 0x73, 0xaa, 0x98, 0x13, 0x4a,
                ])
            
            // disabled to keep the CI flowing
            
            // $0.test(name: "absurd-iterations",
            //     password: "password", salt: "salt", iterations: 16777216,
            //     derived:
            //     [
            //         0xcf, 0x81, 0xc6, 0x6f, 0xe8, 0xcf, 0xc0, 0x4d,
            //         0x1f, 0x31, 0xec, 0xb6, 0x5d, 0xab, 0x40, 0x89,
            //         0xf7, 0xf1, 0x79, 0xe8, 0x9b, 0x3b, 0x0b, 0xcb,
            //         0x17, 0xad, 0x10, 0xe3, 0xac, 0x6e, 0xba, 0x46,
            //     ])
            
            $0.test(name: "multiple-blocks",
                password: "passwordPASSWORDpassword",
                salt: "saltSALTsaltSALTsaltSALTsaltSALTsalt",
                iterations: 4096,
                derived:
                [
                    0x34, 0x8c, 0x89, 0xdb, 0xcb, 0xd3, 0x2b, 0x2f,
                    0x32, 0xd8, 0x14, 0xb8, 0x11, 0x6e, 0x84, 0xcf,
                    0x2b, 0x17, 0x34, 0x7e, 0xbc, 0x18, 0x00, 0x18,
                    0x1c, 0x4e, 0x2a, 0x1f, 0xb8, 0xdd, 0x53, 0xe1,
                    0xc6, 0x35, 0x51, 0x8c, 0x7d, 0xac, 0x47, 0xe9,
                ])
            
            $0.test(name: "null-bytes",
                password: "pass\u{0}word", salt: "sa\u{0}lt",
                iterations: 4096,
                derived:
                [
                    0x89, 0xb6, 0x9d, 0x05, 0x16, 0xf8, 0x29, 0x89,
                    0x3c, 0x69, 0x62, 0x26, 0x65, 0x0a, 0x86, 0x87,
                ])
        }
    }
}
