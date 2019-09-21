---
layout: post
title: "Mining Your Ps and Qs (less and less): 2010 and 2019"
date: 2019-08-07
---

In 2010, not-quite-randomly generated prime numbers allowed a third-party to factor RSA moduli (in bulk). A survey of tens of millions of moduli over [hundreds of millions of domains](https://www.leebutterman.com/2019/08/01/handshaking-the-web-dataset-of-350-million-ssl-connections.html) today shows that this specific vulnerability has been fixed.

## Background

The [establishment of a TLS/SSL connection](https://en.wikipedia.org/wiki/Transport_Layer_Security#Description) relies on asymmetric cryptography: the server keeps a private key, the server distributes a public key, and a client uses a public key to perform a handshake with the server.

Often, the cryptography used has been [RSA](https://en.wikipedia.org/wiki/RSA_(cryptosystem)#Operation), in which the public key is an exponent and a modulus. The modulus is a product of two large primes, and the inability of factoring the modulus into its two primes is what makes the private key private.

With current commodity computers, [integer factorization](https://en.wikipedia.org/wiki/Integer_factorization) looks Significantly Hard as a direct strategy, and an oblique strategy can be significantly faster.

## Bulk integer GCD

The Greatest Common Divisor of two similarly-sized numbers runs proportionally to the square of the number of digits; on a 2018-era laptop, finding the GCD of two numbers a few hundred bytes long takes well under a second.

One's public key modulus usually comes from a machine that randomly picks prime numbers. If not enough randomness is used to generate prime numbers, two moduli can share a prime, and then anyone with one can break the other.

And [that misuse of a prime-number generator](https://algorithmsoup.wordpress.com/2019/01/15/breaking-an-unbreakable-code-part-1-the-hack/) is what had happened several years ago: [Lenstra, Hughes, et alii](https://eprint.iacr.org/2012/064.pdf) found some reuse of primes, as did [Heininger et alii](https://www.usenix.org/system/files/conference/usenixsecurity12/sec12-final228.pdf) (who explained the product/remainder tree for efficiently computing GCDs), and [the EFF started monitoring SSL certificates in its Observatory](https://www.eff.org/observatory).

Taking pairwise GCDs in a dataset of a million or so is expensive enough to be daunting, but running a GCD tree on a few million several-thousand-bit numbers runs in just about an hour on a 2018-era computer. (Hence the reticence in Lenstra to publish the algorithm.)

The GCD tree, as described by Heininger, works roughly as follows:

![](/assets/computing-all-pairs-gcds-efficiently.png)

There are many ways to implement this. Based on [existing language runtime defaults for integer arithmetic](http://www.wilfred.me.uk/blog/2014/10/20/the-fastest-bigint-in-the-west/), Gnu MP is by default in Haskell/Julia/Ruby/Guile/Racket.
One [implementation of batch GCDs in Ruby](https://github.com/lsb/mining-your-ps-and-qs) performs well (as the product starts getting over 1MB in length, the math library time starts representing the vast majority of the runtime, so [make sure you're using GMP](https://github.com/docker-library/ruby/pull/266),
and there is another [batch GCD in Python](https://facthacks.cr.yp.to/batchgcd.html).

## No new vulnerabilities!

No active certs had this vulnerability![^jq] The papers from 2010 indicated that the majority of the undersampled randomness came from only a few systems, none of which are still in use.

However...

Two[^cert1] certs[^cert2] in the scan each had a modulus with a common factor.

[^jq]: The modulus list is `zcat 2019-08-01-ssl-*.gz | grep modulus | jq -r .data.tls.server_certificates.certificate.parsed.subject_key_info.rsa_public_key.modulus | parallel 'echo {} | base64 --decode | xxd -ps -c 10000'` and the bulk GCD is `docker run -i -v $PWD:$PWD -w $PWD ruby ruby $PWD/allgcds.rb`. On a modern computer with more than double the memory of the sum total of bytes in each modulus (which adds up to roughly 10GB), and ample swap space, the GCD of all thirty million integers takes about a day.

[^cert1]:

        {
          "ip": "<nil>",
          "domain": "storage.mithis.com",
          "timestamp": "2019-07-23T03:44:13Z",
          "data": {
            "tls": {
              "server_hello": {
                "version": {
                  "name": "TLSv1.0",
                  "value": 769
                },
                "random": "Km10PXGi4ifDAmcicDOEqhxk1KLpEbr4Qy0GyLj/i28=",
                "session_id": "ZaLsndz3oYdefIX2ch0Umu/y4YKC2Vy+BEADSHKwujA=",
                "cipher_suite": {
                  "hex": "0x000A",
                  "name": "TLS_RSA_WITH_3DES_EDE_CBC_SHA",
                  "value": 10
                },
                "compression_method": 0,
                "ocsp_stapling": false,
                "ticket": false,
                "secure_renegotiation": true,
                "heartbeat": false,
                "extended_master_secret": false
              },
              "server_certificates": {
                "certificate": {
                  "raw": "MIICKzCCAZSgAwIBAgIRAI0FRPMVxk5yGXTR7l7H2gswDQYJKoZIhvcNAQEFBQAwTDEUMBIGA1UEAxMLc2VsZi1zaWduZWQxGTAXBgNVBAMTEHN5c3RlbSBnZW5lcmF0ZWQxGTAXBgNVBAMTEDAxNjIwNTIwMTAwMDEwOTcwHhcNMDEwMTAxMDAwMDUwWhcNMTAxMjMwMDAwMDUwWjBMMRQwEgYDVQQDEwtzZWxmLXNpZ25lZDEZMBcGA1UEAxMQc3lzdGVtIGdlbmVyYXRlZDEZMBcGA1UEAxMQMDE2MjA1MjAxMDAwMTA5NzCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAtaxUhJJc+xmqSrRIfzTw79etGq/xnsPHjzw7lvcmWsqiymZ+X3F2u15uxUrmO6HfGpQ9ggJdPQRKZl2iL5SjImE5FY+umnSfHqpsj+OT14R4wIFXNn0MvCgm3fgJ8hsG7k+D0AkCgEmEWZGF8EVIifeIhyLtlSqR/TMiKPCekVECAwEAAaMNMAswCQYDVR0RBAIwADANBgkqhkiG9w0BAQUFAAOBgQCeoDHVnsSv7E9Pg6aqn/qRebkGQ7dNz3YAfRqLi9hvkBEzpc56hXdZ1vhEcffo0+wFGikGm6U6r0rtaxzobdlyysNJ7WtrP7qVhMm6EWZ1SW53ZK+0MlhZkKq96tCK55rQgpA/STZ3wkwhAoVbU013oQ3H75McHGkjIDhriIClFw==",
                  "parsed": {
                    "version": 3,
                    "serial_number": "187448507353001274465283064650439055883",
                    "signature_algorithm": {
                      "name": "SHA1WithRSA",
                      "oid": "1.2.840.113549.1.1.5"
                    },
                    "issuer": {
                      "common_name": [
                        "self-signed",
                        "system generated",
                        "0162052010001097"
                      ]
                    },
                    "issuer_dn": "CN=self-signed, CN=system generated, CN=0162052010001097",
                    "validity": {
                      "start": "2001-01-01T00:00:50Z",
                      "end": "2010-12-30T00:00:50Z",
                      "length": 315360000
                    },
                    "subject": {
                      "common_name": [
                        "self-signed",
                        "system generated",
                        "0162052010001097"
                      ]
                    },
                    "subject_dn": "CN=self-signed, CN=system generated, CN=0162052010001097",
                    "subject_key_info": {
                      "key_algorithm": {
                        "name": "RSA"
                      },
                      "rsa_public_key": {
                        "exponent": 65537,
                        "modulus": "taxUhJJc+xmqSrRIfzTw79etGq/xnsPHjzw7lvcmWsqiymZ+X3F2u15uxUrmO6HfGpQ9ggJdPQRKZl2iL5SjImE5FY+umnSfHqpsj+OT14R4wIFXNn0MvCgm3fgJ8hsG7k+D0AkCgEmEWZGF8EVIifeIhyLtlSqR/TMiKPCekVE=",
                        "length": 1024
                      },
                      "fingerprint_sha256": "db4f8bb8b1df1e1f016e53b54904e5655b1e46772d920b5f3761fe0185c32204"
                    },
                    "extensions": {
                      "subject_alt_name": {}
                    },
                    "signature": {
                      "signature_algorithm": {
                        "name": "SHA1WithRSA",
                        "oid": "1.2.840.113549.1.1.5"
                      },
                      "value": "nqAx1Z7Er+xPT4Omqp/6kXm5BkO3Tc92AH0ai4vYb5ARM6XOeoV3Wdb4RHH36NPsBRopBpulOq9K7Wsc6G3ZcsrDSe1raz+6lYTJuhFmdUlud2SvtDJYWZCqverQiuea0IKQP0k2d8JMIQKFW1NNd6ENx++THBxpIyA4a4iApRc=",
                      "valid": false,
                      "self_signed": true
                    },
                    "fingerprint_md5": "79113e71433ef77aefeaaff16ec43e32",
                    "fingerprint_sha1": "e5c6e30aa96978f230a663aa9a155a31d0983c16",
                    "fingerprint_sha256": "38c4c2b2284f2c0674eff1841efe657eed35a40ad565f0af98ba098dc0dd4b63",
                    "tbs_noct_fingerprint": "30beddde2edb293447a19ffcdb2959f29e9862f909ce16b4b69b1b5c70543b0c",
                    "spki_subject_fingerprint": "f662f2a2544c4681bcb2bab3b0f9c4828afbe2abbe6111d44dff2d17e568264b",
                    "tbs_fingerprint": "30beddde2edb293447a19ffcdb2959f29e9862f909ce16b4b69b1b5c70543b0c",
                    "validation_level": "unknown",
                    "redacted": false
                  }
                },
                "validation": {
                  "browser_trusted": false,
                  "browser_error": "x509: unknown error"
                }
              },
              "server_finished": {
                "verify_data": "xaMH/dmCnFv9T5tS"
              }
            }
          }
        }

[^cert2]:

        {
          "ip": "<nil>",
          "domain": "patient.clinique-cital.com",
          "timestamp": "2019-07-23T08:20:00Z",
          "data": {
            "tls": {
              "server_hello": {
                "version": {
                  "name": "TLSv1.0",
                  "value": 769
                },
                "random": "Km02U09cWfBpLF+v3CCsf+v9/9r1VKe+W5QOBD4mY0k=",
                "session_id": "KW+2H99kZfZEMzTifa6VXS5djV5/ROn/opQ4M0L+00Q=",
                "cipher_suite": {
                  "hex": "0x000A",
                  "name": "TLS_RSA_WITH_3DES_EDE_CBC_SHA",
                  "value": 10
                },
                "compression_method": 0,
                "ocsp_stapling": false,
                "ticket": false,
                "secure_renegotiation": true,
                "heartbeat": false,
                "extended_master_secret": false
              },
              "server_certificates": {
                "certificate": {
                  "raw": "MIICKjCCAZOgAwIBAgIQPZhtKnCW5NnN1lXdi/kYLzANBgkqhkiG9w0BAQUFADBMMRQwEgYDVQQDEwtzZWxmLXNpZ25lZDEZMBcGA1UEAxMQc3lzdGVtIGdlbmVyYXRlZDEZMBcGA1UEAxMQMDE2MjAyMjAxNDAwMTkxNDAeFw0wMTAxMDEwMDAwNTJaFw0xMDEyMzAwMDAwNTJaMEwxFDASBgNVBAMTC3NlbGYtc2lnbmVkMRkwFwYDVQQDExBzeXN0ZW0gZ2VuZXJhdGVkMRkwFwYDVQQDExAwMTYyMDIyMDE0MDAxOTE0MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC+seklvb3CPcnXfGvuET9umuzOvLvzk7DGV5ejvTlI0NsFprUDkXFXNzIMFmbIKNaX6gjZkHvYw3tCgX1iYTUP753h3hdoOGRnNWhl5+9H0wJJjO7JqPuDlerfPMECDoEQUWR9QLltGFAlj1j2LpvlyvL4Mzo3WlzdLb+UNIZW5QIDAQABow0wCzAJBgNVHREEAjAAMA0GCSqGSIb3DQEBBQUAA4GBAGKw8hVgAqegWfiF2w2JMoGe9qXf9btZJtGHgwDpbNZnGqvzpxjGLIvSOj3VFcluf3spUjha9cZnvcc4OD7rVmAehL/NH4QnkReNomNo4WMxLkD9XHA6HCOVMewHg4EnnUq5dS2CFMQuLOYxuIumMbtINc4hivj9NZWPPIYqZ7HW",
                  "parsed": {
                    "version": 3,
                    "serial_number": "81874351010451526368113792478657189935",
                    "signature_algorithm": {
                      "name": "SHA1WithRSA",
                      "oid": "1.2.840.113549.1.1.5"
                    },
                    "issuer": {
                      "common_name": [
                        "self-signed",
                        "system generated",
                        "0162022014001914"
                      ]
                    },
                    "issuer_dn": "CN=self-signed, CN=system generated, CN=0162022014001914",
                    "validity": {
                      "start": "2001-01-01T00:00:52Z",
                      "end": "2010-12-30T00:00:52Z",
                      "length": 315360000
                    },
                    "subject": {
                      "common_name": [
                        "self-signed",
                        "system generated",
                        "0162022014001914"
                      ]
                    },
                    "subject_dn": "CN=self-signed, CN=system generated, CN=0162022014001914",
                    "subject_key_info": {
                      "key_algorithm": {
                        "name": "RSA"
                      },
                      "rsa_public_key": {
                        "exponent": 65537,
                        "modulus": "vrHpJb29wj3J13xr7hE/bprszry785OwxleXo705SNDbBaa1A5FxVzcyDBZmyCjWl+oI2ZB72MN7QoF9YmE1D++d4d4XaDhkZzVoZefvR9MCSYzuyaj7g5Xq3zzBAg6BEFFkfUC5bRhQJY9Y9i6b5cry+DM6N1pc3S2/lDSGVuU=",
                        "length": 1024
                      },
                      "fingerprint_sha256": "127c7ef1b65b89d38ddd16157f9037ca912c5b20a59f70433b8d6e964a86cbd5"
                    },
                    "extensions": {
                      "subject_alt_name": {}
                    },
                    "signature": {
                      "signature_algorithm": {
                        "name": "SHA1WithRSA",
                        "oid": "1.2.840.113549.1.1.5"
                      },
                      "value": "YrDyFWACp6BZ+IXbDYkygZ72pd/1u1km0YeDAOls1mcaq/OnGMYsi9I6PdUVyW5/eylSOFr1xme9xzg4PutWYB6Ev80fhCeRF42iY2jhYzEuQP1ccDocI5Ux7AeDgSedSrl1LYIUxC4s5jG4i6Yxu0g1ziGK+P01lY88hipnsdY=",
                      "valid": false,
                      "self_signed": true
                    },
                    "fingerprint_md5": "8b892342789817ddf5d84b7d5d3e31ca",
                    "fingerprint_sha1": "74c7dc80f1ff5d923d8894908efb2346fba046eb",
                    "fingerprint_sha256": "c0b67a71eeabd65bedec2b30c19e08aeabc8ce97f1871c37956517eb91914ea6",
                    "tbs_noct_fingerprint": "49a58f75fa503e75ba46f392de65ffd626a4208b3ac03956070034c6964f03ca",
                    "spki_subject_fingerprint": "7450c9ceed6bd49fb8023c145de2ed4b3e33908dfacfa75a776a2c35a1ee23f9",
                    "tbs_fingerprint": "49a58f75fa503e75ba46f392de65ffd626a4208b3ac03956070034c6964f03ca",
                    "validation_level": "unknown",
                    "redacted": false
                  }
                },
                "validation": {
                  "browser_trusted": false,
                  "browser_error": "x509: unknown error"
                }
              },
              "server_finished": {
                "verify_data": "wSHjQZG1N2JgjT5G"
              }
            }
          }
        }



Both were self-signed.

Both expired on 30 Dec 2010, about 2 seconds apart. (These were actively served up to get compiled into the dataset on 23 July 2019, over 8 years after expiry.)


I've reached out to the owner of one of those, and will post any updates. 

----

