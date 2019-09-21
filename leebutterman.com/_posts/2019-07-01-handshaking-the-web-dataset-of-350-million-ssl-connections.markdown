---
layout: post
title: "Handshaking the Web: hundreds of millions of SSL connections"
date: 2019-08-01
---

## `s3://zgrab-the-web`

Not finding an existing open dataset of "how does the web use SSL these days", I made one myself, over a few days. It's publicly available, check it out!

The dataset is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.

## zgrab

The zmap project includes a suite of tools useful for large-scale study of the internet. One can pass IP addresses or domain names to `zgrab` and receive a JSON object containing the success/failure of the SSL handshake to each domain.

## The Web

The Common Crawl has been compiling a compendium of the web for many years. There are indices for the shards of the crawl, and these indices contain the full URL of every page crawled.

## Do Try This At Home

Try this on any computer with a robust network connection and DNS provider! Run `make` with [the corresponding code](https://github.com/lsb/zgrab-the-web) to regenerate. 

## Details

There's 12 shards, `2019-08-01-ssl-00` through `-ssl-11`, along with corresponding `2019-08-01-fqdns-00` through `-fqdns-11` as an index to which fully-qualified domain names were scanned in each shard.

The `ssl` shards are newline-delimited JSON from `zgrab`, suitable for further analysis with programs like `jq`, or insertion into a database column (potentially with functional indices) in PostgreSQL or SQLite.

For instance, the record of the connection to this domain name is 

```
{
  "ip": "<nil>",
  "domain": "leebutterman.com",
  "timestamp": "2019-07-23T17:05:43Z",
  "data": {
    "tls": {
      "server_hello": {
        "version": {
          "name": "TLSv1.2",
          "value": 771
        },
        "random": "YxsPVSkXKHVRhRKDW+sAzO9Wq5YD9ygVRE9XTkdSRAE=",
        "session_id": "",
        "cipher_suite": {
          "hex": "0xC02B",
          "name": "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256",
          "value": 49195
        },
        "compression_method": 0,
        "ocsp_stapling": true,
        "ticket": false,
        "secure_renegotiation": true,
        "heartbeat": false,
        "extended_master_secret": false
      },
      "server_certificates": {
        "certificate": {
          "raw": "MIIEjjCCA3agAwIBAgISA/NwMMQDVSEMOShLwYoslUkmMA0GCSqGSIb3DQEBCwUAMEoxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBFbmNyeXB0MSMwIQYDVQQDExpMZXQncyBFbmNyeXB0IEF1dGhvcml0eSBYMzAeFw0xOTA3MTMwNzM4MTdaFw0xOTEwMTEwNzM4MTdaMBsxGTAXBgNVBAMTEGxlZWJ1dHRlcm1hbi5jb20wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAATD/1KSf+76pFACCA0o4bsuYGpCO5ty0x2OnQSa8miuSpTY3DVK0TY8bHv7lr4OmWHpDqqia+lVLd0FOT7Y8KO8o4ICZjCCAmIwDgYDVR0PAQH/BAQDAgeAMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjAMBgNVHRMBAf8EAjAAMB0GA1UdDgQWBBSurDGuUQwbaZNbbCJllERDKPR85DAfBgNVHSMEGDAWgBSoSmpjBH3duubRObemRWXv86jsoTBvBggrBgEFBQcBAQRjMGEwLgYIKwYBBQUHMAGGImh0dHA6Ly9vY3NwLmludC14My5sZXRzZW5jcnlwdC5vcmcwLwYIKwYBBQUHMAKGI2h0dHA6Ly9jZXJ0LmludC14My5sZXRzZW5jcnlwdC5vcmcvMBsGA1UdEQQUMBKCEGxlZWJ1dHRlcm1hbi5jb20wTAYDVR0gBEUwQzAIBgZngQwBAgEwNwYLKwYBBAGC3xMBAQEwKDAmBggrBgEFBQcCARYaaHR0cDovL2Nwcy5sZXRzZW5jcnlwdC5vcmcwggEFBgorBgEEAdZ5AgQCBIH2BIHzAPEAdwDiaUuuJujpQAnohhu2O4PUPuf+dIj7pI8okwGd3fHb/gAAAWvqe5j3AAAEAwBIMEYCIQDPHm5UhQfWPMeL/g5S0walJpZuIqxLHdGRDMpEZ86T0QIhAIPeZp/Bner/Ewzpqhpm0o9k4G50Rcs5eTGZCZujZ+7CAHYAKTxRllTIOWW6qlD8WAfUt2+/WHopctykwwz05UVH9HgAAAFr6nuZHgAABAMARzBFAiEA1doDO2tlVCjdT181ZNuHbiILe7htBfwP8rHFl4VBoDQCIDAo2CEOK+Of1BkJeg5lSr0aLOSk6jHedPYvvXjVvX0aMA0GCSqGSIb3DQEBCwUAA4IBAQAHEC2lsw7YOXp4ZGRIgVmie4kxBNL4T2T1ublBTOQ0EWgalsbigz2L9/EwGXIvyd0xD3FoPsQmuCOX9HocOQ//I2Q+BSwBBcSOwayiseUSDVL3fzr+191otg6m4fBGfmLcWJ45tfdFlFmfawG4CMuf13sF7CD0VMEmBf+NogUuoHRjthHHRqIgP9UAMfseKnuHap6XGoa+dxoi3C3mcD8kz60A/y0+nMmEWLGKHO0eDpLFGtC9VE35h15g/0WBWe2A6vxnKxXrBtNaWqNrKlFdCOUsBSXGlYJbTfqGJA8TMwnqsaqThkOWTQNAiRCMWoOKQ0EoUeJfAfA4Bud66FIA",
          "parsed": {
            "version": 3,
            "serial_number": "344174599698462219792342947521960273594662",
            "signature_algorithm": {
              "name": "SHA256WithRSA",
              "oid": "1.2.840.113549.1.1.11"
            },
            "issuer": {
              "common_name": [
                "Let's Encrypt Authority X3"
              ],
              "country": [
                "US"
              ],
              "organization": [
                "Let's Encrypt"
              ]
            },
            "issuer_dn": "C=US, O=Let's Encrypt, CN=Let's Encrypt Authority X3",
            "validity": {
              "start": "2019-07-13T07:38:17Z",
              "end": "2019-10-11T07:38:17Z",
              "length": 7776000
            },
            "subject": {
              "common_name": [
                "leebutterman.com"
              ]
            },
            "subject_dn": "CN=leebutterman.com",
            "subject_key_info": {
              "key_algorithm": {
                "name": "ECDSA"
              },
              "ecdsa_public_key": {
                "b": "WsY12Ko6k+ez671VdpiGvGUdBrDMU7D2O848PifSYEs=",
                "curve": "P-256",
                "gx": "axfR8uEsQkf4vOblY6RA8ncDfYEt6zOg9KE5RdiYwpY=",
                "gy": "T+NC4v4af5uO5+tKfA+eFivOM1drMV7Oy7ZAaDe/UfU=",
                "length": 256,
                "n": "/////wAAAAD//////////7zm+q2nF56E87nKwvxjJVE=",
                "p": "/////wAAAAEAAAAAAAAAAAAAAAD///////////////8=",
                "pub": "BMP/UpJ/7vqkUAIIDSjhuy5gakI7m3LTHY6dBJryaK5KlNjcNUrRNjxse/uWvg6ZYekOqqJr6VUt3QU5Ptjwo7w=",
                "x": "w/9Skn/u+qRQAggNKOG7LmBqQjubctMdjp0EmvJorko=",
                "y": "lNjcNUrRNjxse/uWvg6ZYekOqqJr6VUt3QU5Ptjwo7w="
              },
              "fingerprint_sha256": "b63c48dae595b85fa12c9aaf9e1a69c13a7842fb366e734671d8403266d8b662"
            },
            "extensions": {
              "key_usage": {
                "digital_signature": true,
                "value": 1
              },
              "basic_constraints": {
                "is_ca": false
              },
              "subject_alt_name": {
                "dns_names": [
                  "leebutterman.com"
                ]
              },
              "authority_key_id": "a84a6a63047dddbae6d139b7a64565eff3a8eca1",
              "subject_key_id": "aeac31ae510c1b69935b6c226594444328f47ce4",
              "extended_key_usage": {
                "client_auth": true,
                "server_auth": true
              },
              "certificate_policies": [
                {
                  "id": "2.23.140.1.2.1"
                },
                {
                  "id": "1.3.6.1.4.1.44947.1.1.1",
                  "cps": [
                    "http://cps.letsencrypt.org"
                  ]
                }
              ],
              "authority_info_access": {
                "ocsp_urls": [
                  "http://ocsp.int-x3.letsencrypt.org"
                ],
                "issuer_urls": [
                  "http://cert.int-x3.letsencrypt.org/"
                ]
              },
              "signed_certificate_timestamps": [
                {
                  "version": 0,
                  "log_id": "4mlLribo6UAJ6IYbtjuD1D7n/nSI+6SPKJMBnd3x2/4=",
                  "timestamp": 1563007097,
                  "signature": "BAMASDBGAiEAzx5uVIUH1jzHi/4OUtMGpSaWbiKsSx3RkQzKRGfOk9ECIQCD3mafwZ3q/xMM6aoaZtKPZOBudEXLOXkxmQmbo2fuwg=="
                },
                {
                  "version": 0,
                  "log_id": "KTxRllTIOWW6qlD8WAfUt2+/WHopctykwwz05UVH9Hg=",
                  "timestamp": 1563007097,
                  "signature": "BAMARzBFAiEA1doDO2tlVCjdT181ZNuHbiILe7htBfwP8rHFl4VBoDQCIDAo2CEOK+Of1BkJeg5lSr0aLOSk6jHedPYvvXjVvX0a"
                }
              ]
            },
            "signature": {
              "signature_algorithm": {
                "name": "SHA256WithRSA",
                "oid": "1.2.840.113549.1.1.11"
              },
              "value": "BxAtpbMO2Dl6eGRkSIFZonuJMQTS+E9k9bm5QUzkNBFoGpbG4oM9i/fxMBlyL8ndMQ9xaD7EJrgjl/R6HDkP/yNkPgUsAQXEjsGsorHlEg1S9386/tfdaLYOpuHwRn5i3FieObX3RZRZn2sBuAjLn9d7Bewg9FTBJgX/jaIFLqB0Y7YRx0aiID/VADH7Hip7h2qelxqGvncaItwt5nA/JM+tAP8tPpzJhFixihztHg6SxRrQvVRN+YdeYP9FgVntgOr8ZysV6wbTWlqjaypRXQjlLAUlxpWCW036hiQPEzMJ6rGqk4ZDlk0DQIkQjFqDikNBKFHiXwHwOAbneuhSAA==",
              "valid": true,
              "self_signed": false
            },
            "fingerprint_md5": "f2fd7a11f1c7d1a82d67c57fe196c4a4",
            "fingerprint_sha1": "c9610c491c062060ebb559322be13904a86c5427",
            "fingerprint_sha256": "81e61c4c86bdfec0c3af382b0015cb29efcb82374261a2c1054e355f85c22fcc",
            "tbs_noct_fingerprint": "244e1436d8eafaf6daa7a5c936df08740fbe8069b0d5524eab1c2e4087dbe395",
            "spki_subject_fingerprint": "1782b59eb4f42f2aaaacba153ef69538a3e60d74fdc5b4be5ef2192de1854422",
            "tbs_fingerprint": "7b6157ddcb861df16d295e2386bba00730a93d04a9950cbd8b1879efeaf9d3a2",
            "validation_level": "DV",
            "names": [
              "leebutterman.com"
            ],
            "redacted": false
          }
        },
        "chain": [
          {
            "raw": "MIIEkjCCA3qgAwIBAgIQCgFBQgAAAVOFc2oLheynCDANBgkqhkiG9w0BAQsFADA/MSQwIgYDVQQKExtEaWdpdGFsIFNpZ25hdHVyZSBUcnVzdCBDby4xFzAVBgNVBAMTDkRTVCBSb290IENBIFgzMB4XDTE2MDMxNzE2NDA0NloXDTIxMDMxNzE2NDA0NlowSjELMAkGA1UEBhMCVVMxFjAUBgNVBAoTDUxldCdzIEVuY3J5cHQxIzAhBgNVBAMTGkxldCdzIEVuY3J5cHQgQXV0aG9yaXR5IFgzMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnNMM8FrlLke3cl03g7NoYzDq1zUmGSXhvb418XCSL7e4S0EFq6meNQhY7LEqxGiHC6PjdeTm86dicbp5gWAf15Gan/PQeGdxyGkOlZHP/uaZ6WA8SMx+yk13EiSdRxta67nsHjcAHJyse6cF6s5K671B5TaYucv9bTyWaN8jKkKQDIZ0Z8h/pZq4UmEUEz9l6YKHy9v6Dlb2honzhT+Xhq+w3Brvaw2VFn3EK6BlspkENnWAa6xK8xuQSXgvopZPKiAlKQTGdMDQMc2PMTiVFrqoM7hD8bEfwzB/onkxEz0tNvjj/PIzark5McWvxI0NHWQWM6r6hCm21AvA2H3DkwIDAQABo4IBfTCCAXkwEgYDVR0TAQH/BAgwBgEB/wIBADAOBgNVHQ8BAf8EBAMCAYYwfwYIKwYBBQUHAQEEczBxMDIGCCsGAQUFBzABhiZodHRwOi8vaXNyZy50cnVzdGlkLm9jc3AuaWRlbnRydXN0LmNvbTA7BggrBgEFBQcwAoYvaHR0cDovL2FwcHMuaWRlbnRydXN0LmNvbS9yb290cy9kc3Ryb290Y2F4My5wN2MwHwYDVR0jBBgwFoAUxKexpHsscfrb4UuQdf/EFWCFiRAwVAYDVR0gBE0wSzAIBgZngQwBAgEwPwYLKwYBBAGC3xMBAQEwMDAuBggrBgEFBQcCARYiaHR0cDovL2Nwcy5yb290LXgxLmxldHNlbmNyeXB0Lm9yZzA8BgNVHR8ENTAzMDGgL6AthitodHRwOi8vY3JsLmlkZW50cnVzdC5jb20vRFNUUk9PVENBWDNDUkwuY3JsMB0GA1UdDgQWBBSoSmpjBH3duubRObemRWXv86jsoTANBgkqhkiG9w0BAQsFAAOCAQEA3TPXEfNjWDjdGBX7CVW+dla5cEilaUcne8IkCJLxWh9KEik3JHRRHGJouM2VcGfl96S8TihRzZvoroed6ti6WqEBmtzw3Wodatg+VyOeph4EYpr/1wXKtx8/wApIvJSwtmVi4MFU5aMqrSDE6ea73Mj2tcMyo5jMd6jmeWUHK8so/joWUoHOUgwuX4Po1QYz+3dszkDqMp4fklxBwXRsW10KXzPMTZ+sOPAveyxindmjkW8lGy+QsRlGPfZ+G6Z6h7mjem0Y+iWlkYcV4PIWL1iwBi8saCbGS5jN2p8M+X+Q7UNKEkROb3N6KOqkqm57TH2H3eDJAkSnh6/DNFu0Qg==",
            "parsed": {
              "version": 3,
              "serial_number": "13298795840390663119752826058995181320",
              "signature_algorithm": {
                "name": "SHA256WithRSA",
                "oid": "1.2.840.113549.1.1.11"
              },
              "issuer": {
                "common_name": [
                  "DST Root CA X3"
                ],
                "organization": [
                  "Digital Signature Trust Co."
                ]
              },
              "issuer_dn": "O=Digital Signature Trust Co., CN=DST Root CA X3",
              "validity": {
                "start": "2016-03-17T16:40:46Z",
                "end": "2021-03-17T16:40:46Z",
                "length": 157766400
              },
              "subject": {
                "common_name": [
                  "Let's Encrypt Authority X3"
                ],
                "country": [
                  "US"
                ],
                "organization": [
                  "Let's Encrypt"
                ]
              },
              "subject_dn": "C=US, O=Let's Encrypt, CN=Let's Encrypt Authority X3",
              "subject_key_info": {
                "key_algorithm": {
                  "name": "RSA"
                },
                "rsa_public_key": {
                  "exponent": 65537,
                  "modulus": "nNMM8FrlLke3cl03g7NoYzDq1zUmGSXhvb418XCSL7e4S0EFq6meNQhY7LEqxGiHC6PjdeTm86dicbp5gWAf15Gan/PQeGdxyGkOlZHP/uaZ6WA8SMx+yk13EiSdRxta67nsHjcAHJyse6cF6s5K671B5TaYucv9bTyWaN8jKkKQDIZ0Z8h/pZq4UmEUEz9l6YKHy9v6Dlb2honzhT+Xhq+w3Brvaw2VFn3EK6BlspkENnWAa6xK8xuQSXgvopZPKiAlKQTGdMDQMc2PMTiVFrqoM7hD8bEfwzB/onkxEz0tNvjj/PIzark5McWvxI0NHWQWM6r6hCm21AvA2H3Dkw==",
                  "length": 2048
                },
                "fingerprint_sha256": "60b87575447dcba2a36b7d11ac09fb24a9db406fee12d2cc90180517616e8a18"
              },
              "extensions": {
                "key_usage": {
                  "digital_signature": true,
                  "certificate_sign": true,
                  "crl_sign": true,
                  "value": 97
                },
                "basic_constraints": {
                  "is_ca": true,
                  "max_path_len": 0
                },
                "crl_distribution_points": [
                  "http://crl.identrust.com/DSTROOTCAX3CRL.crl"
                ],
                "authority_key_id": "c4a7b1a47b2c71fadbe14b9075ffc41560858910",
                "subject_key_id": "a84a6a63047dddbae6d139b7a64565eff3a8eca1",
                "certificate_policies": [
                  {
                    "id": "2.23.140.1.2.1"
                  },
                  {
                    "id": "1.3.6.1.4.1.44947.1.1.1",
                    "cps": [
                      "http://cps.root-x1.letsencrypt.org"
                    ]
                  }
                ],
                "authority_info_access": {
                  "ocsp_urls": [
                    "http://isrg.trustid.ocsp.identrust.com"
                  ],
                  "issuer_urls": [
                    "http://apps.identrust.com/roots/dstrootcax3.p7c"
                  ]
                }
              },
              "signature": {
                "signature_algorithm": {
                  "name": "SHA256WithRSA",
                  "oid": "1.2.840.113549.1.1.11"
                },
                "value": "3TPXEfNjWDjdGBX7CVW+dla5cEilaUcne8IkCJLxWh9KEik3JHRRHGJouM2VcGfl96S8TihRzZvoroed6ti6WqEBmtzw3Wodatg+VyOeph4EYpr/1wXKtx8/wApIvJSwtmVi4MFU5aMqrSDE6ea73Mj2tcMyo5jMd6jmeWUHK8so/joWUoHOUgwuX4Po1QYz+3dszkDqMp4fklxBwXRsW10KXzPMTZ+sOPAveyxindmjkW8lGy+QsRlGPfZ+G6Z6h7mjem0Y+iWlkYcV4PIWL1iwBi8saCbGS5jN2p8M+X+Q7UNKEkROb3N6KOqkqm57TH2H3eDJAkSnh6/DNFu0Qg==",
                "valid": true,
                "self_signed": false
              },
              "fingerprint_md5": "b15409274f54ad8f023d3b85a5ecec5d",
              "fingerprint_sha1": "e6a3b45b062d509b3382282d196efe97d5956ccb",
              "fingerprint_sha256": "25847d668eb4f04fdd40b12b6b0740c567da7d024308eb6c2c96fe41d9de218d",
              "tbs_noct_fingerprint": "3e1a1a0f6c53f3e97a492d57084b5b9807059ee057ab1505876fd83fda3db838",
              "spki_subject_fingerprint": "78d2913356ad04f8f362019df6cb4f4f8b003be0d2aa0d1cb37d2fd326b09c9e",
              "tbs_fingerprint": "3e1a1a0f6c53f3e97a492d57084b5b9807059ee057ab1505876fd83fda3db838",
              "validation_level": "DV",
              "redacted": false
            }
          }
        ],
        "validation": {
          "browser_trusted": true,
          "matches_domain": true
        }
      },
      "server_key_exchange": {
        "ecdh_params": {
          "curve_id": {
            "name": "secp256r1",
            "id": 23
          },
          "server_public": {
            "x": {
              "value": "iw/SvV+NkG9CeT/ZVncp++BdUeTNZ7Sm6GSvBmFGtx8=",
              "length": 256
            },
            "y": {
              "value": "FAsSo9KOSoQDBWka92AXKNpah1/Y5h64znarXQHGpK4=",
              "length": 256
            }
          }
        },
        "digest": "O62NX7Hp96z+Q3gyn82suGhMp90kYDlfmq3RFwSTgKlREHgd5e3t4KutEZjV2cS4jn+r4TBHQYs365aYubetCQ==",
        "signature": {
          "raw": "MEUCIQC19glPcCXwS8iAow8/hHYG6jLIj6lleZaWCws+8rOIUQIgbYa7+/vWREH7YnyNhxr5tag/LcWhMAyt4iw0y3DSVks=",
          "type": "ecdsa",
          "valid": true,
          "signature_and_hash_type": {
            "signature_algorithm": "ecdsa",
            "hash_algorithm": "sha512"
          },
          "tls_version": {
            "name": "TLSv1.2",
            "value": 771
          }
        }
      },
      "server_finished": {
        "verify_data": "uawNPwngY+d0CDhZ"
      }
    }
  }
}
```