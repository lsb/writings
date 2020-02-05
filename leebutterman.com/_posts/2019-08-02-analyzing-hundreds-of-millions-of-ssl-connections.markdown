---
layout: post
title: "Let's Encrypt makes certs for almost 30% of web domains! RC4/3DES/TLS 1.0 are still used! Certs for hundreds of years! Analyzing hundreds of millions of SSL handshakes"
date: 2019-08-05
---

Looking at a [dataset of 350 million ssl connections](https://www.leebutterman.com/2019/08/01/handshaking-the-web-dataset-of-350-million-ssl-connections.html) inspires some initial questions:

* who made the certs
* what crypto powers it
* what sort of life time

## Let's Encrypt makes certs for almost 30% of web domains 

The [server](/) you're reading this on uses automated certs from Let's Encrypt---they are more common on a domain than any other registrar! Over 47 million domains are protected with Let's Encrypt certs, almost 30%.

Out of 352.3M domains, the dataset has 158.7M connections that proceeded far enough to provide a certificate with an issuer's Distinguished Name. The top dozen[^issuer_dn] are: 

| 47.2M | Let's Encrypt |
| 28.9M | DigiCert |
| 13.8M | Comodo |
| 10.1M | Google |
|  7.2M | GoDaddy |
|  7.1M | Sectigo |
|  7.0M | cPanel |
|  6.1M | GlobalSign |
|  3.4M | CloudFlare0 |
|  2.5M | Amazon |
|  2.1M | (anonymous self-signed) |
|  1.1M | Plesk |


[^issuer_dn]:
    The aggregate `issuer_dn`s that appeared more than 100K times are

        193590544 null
        47237383 C=US, O=Let's Encrypt, CN=Let's Encrypt Authority X3
        13367305 C=US, O=DigiCert Inc, OU=www.digicert.com, CN=DigiCert SHA2 High Assurance Server CA
        13092572 C=GB, ST=Greater Manchester, L=Salford, O=COMODO CA Limited, CN=COMODO RSA Domain Validation Secure Server CA
        10081610 C=US, O=Google Trust Services, CN=Google Internet Authority G3
        7048258 C=US, ST=TX, L=Houston, O=cPanel, Inc., CN=cPanel, Inc. Certification Authority
        6772537 C=GB, ST=Greater Manchester, L=Salford, O=Sectigo Limited, CN=Sectigo RSA Domain Validation Secure Server CA
        4946970 C=US, O=DigiCert Inc, OU=www.digicert.com, CN=RapidSSL RSA CA 2018
        3926261 C=GB, ST=Greater Manchester, L=Salford, O=COMODO CA Limited, CN=COMODO ECC Domain Validation Secure Server CA 2
        3727005 C=US, ST=Arizona, L=Scottsdale, O=GoDaddy.com, Inc., OU=http://certs.godaddy.com/repository/, CN=Go Daddy Secure Certificate Authority - G2
        3483129 C=US, ST=Arizona, L=Scottsdale, O=Starfield Technologies, Inc., OU=http://certs.starfieldtech.com/repository/, CN=Starfield Secure Certificate Authority - G2
        3404488 C=US, ST=CA, L=San Francisco, O=CloudFlare, Inc., CN=CloudFlare Inc ECC CA-2
        2523036 C=US, O=Amazon, OU=Server CA 1B, CN=Amazon
        2498667 C=US, O=DigiCert Inc, OU=www.digicert.com, CN=Thawte TLS RSA CA G1
        2431104 C=BE, O=GlobalSign nv-sa, CN=GlobalSign Domain Validation CA - SHA256 - G2
        2422131 C=BE, O=GlobalSign nv-sa, CN=AlphaSSL CA - SHA256 - G2
        2310140 C=US, O=DigiCert Inc, CN=DigiCert SHA2 Secure Server CA
        1791127 C=US, O=DigiCert Inc, OU=www.digicert.com, CN=Encryption Everywhere DV TLS CA - G1
        1298054 C=GB, ST=Greater Manchester, L=Salford, O=COMODO CA Limited, CN=COMODO RSA Organization Validation Secure Server CA
        1019337 C=US, O=DigiCert Inc, OU=www.digicert.com, CN=GeoTrust RSA CA 2018
         853367 C=US, O=DigiCert Inc, CN=DigiCert ECC Secure Server CA
         842994 C=US, ST=Someprovince, L=Sometown, O=none, OU=none, CN=localhost, emailAddress=webmaster@localhost
         828175 C=CH, L=Schaffhausen, O=Plesk, CN=Plesk, emailAddress=info@plesk.com
         800601 C=US, O=DigiCert Inc, OU=www.digicert.com, CN=Thawte RSA CA 2018
         736336 C=BE, O=GlobalSign nv-sa, CN=GlobalSign Organization Validation CA - SHA256 - G2
         679798 C=FR, ST=Paris, L=Paris, O=Gandi, CN=Gandi Standard SSL CA 2
         648187 OU=Default Web server, CN=www.example.com, emailAddress=postmaster@example.com
         572342 C=--, ST=SomeState, L=SomeCity, O=SomeOrganization, OU=SomeOrganizationalUnit, CN=server.ab-archive.net, emailAddress=root@server.ab-archive.net
         546456 C=DE, ST=Bayern, L=Muenchen, O=ispgateway, CN=webserver.ispgateway.de, emailAddress=hostmaster@ispgateway.de
         501592 C=US, ST=Virginia, L=Herndon, O=Parallels, OU=Parallels Panel, CN=Parallels Panel, emailAddress=info@parallels.com
         501093 C=US, ST=California, O=DreamHost, CN=sni.dreamhost.com
         480468 C=CN, O=TrustAsia Technologies, Inc., OU=Domain Validated SSL, CN=TrustAsia TLS RSA CA
         468190 C=BE, O=GlobalSign nv-sa, CN=GlobalSign CloudSSL CA - SHA256 - G3
         464242 C=--, ST=SomeState, L=SomeCity, O=SomeOrganization, OU=SomeOrganizationalUnit, CN=localhost.localdomain, emailAddress=root@localhost.localdomain
         455067 C=PL, O=home.pl S.A., CN=Certyfikat SSL
         445550 C=US, O=DigiCert Inc, OU=www.digicert.com, CN=Encryption Everywhere DV TLS CA - G2
         417062 C=PL, O=Unizeto Technologies S.A., OU=Certum Certification Authority, CN=Certum Domain Validation CA SHA2
         416966 C=JP, ST=Tokyo, L=Chiyoda-ku, O=Gehirn Inc., CN=Gehirn Managed Certification Authority - RSA DV
         384480 C=IT, ST=Bergamo, L=Ponte San Pietro, O=Actalis S.p.A./03358520967, CN=Actalis Organization Validated Server CA G2
         368708 C=JP, ST=OSAKA, L=OSAKA, O=SecureCore, CN=SecureCore RSA DV CA
         353716 C=US, O=DigiCert Inc, OU=www.digicert.com, CN=RapidSSL TLS RSA CA G1
         343034 C=US, O=DigiCert Inc, CN=DigiCert Global CA G2
         278170 C=PL, O=nazwa.pl sp. z o.o., OU=http://nazwa.pl, CN=nazwaSSL
         267784 C=US, ST=Illinois, L=Chicago, O=Trustwave Holdings, Inc., CN=Trustwave Organization Validation SHA256 CA, Level 1, emailAddress=ca@trustwave.com
         251987 C=IT, ST=Bergamo, L=Ponte San Pietro, O=Actalis S.p.A./03358520967, CN=Actalis Domain Validation Server CA G2
         244273 C=JP, O=Cybertrust Japan Co., Ltd., CN=Cybertrust Japan Public CA G3
         236608 C=US, ST=Washington, L=Seattle, O=Odin, OU=Plesk, CN=Plesk, emailAddress=info@plesk.com
         228615 C=GB, ST=Greater Manchester, L=Salford, O=Sectigo Limited, CN=Sectigo RSA Organization Validation Secure Server CA
         202529 C=US, O=DigiCert Inc, OU=www.digicert.com, CN=GeoTrust TLS RSA CA G1
         184627 C=US, ST=MI, L=Ann Arbor, O=Internet2, OU=InCommon, CN=InCommon RSA Server CA
         184276 C=US, O=Entrust, Inc., OU=See www.entrust.net/legal-terms, OU=(c) 2012 Entrust, Inc. - for authorized use only, CN=Entrust Certification Authority - L1K
         177315 C=NL, ST=Noord-Holland, L=Amsterdam, O=TERENA, CN=TERENA SSL CA 3
         171469 C=LV, L=Riga, O=GoGetSSL, CN=GoGetSSL RSA DV CA
         168933 C=US, O=GeoTrust Inc., CN=RapidSSL SHA256 CA
         150830 C=RU, ST=Moscow, L=Moscow, O=Odin, OU=Odin Automation, CN=odin.com, emailAddress=webmaster@odin.com
         122399 C=JP, O=Japan Registry Services Co., Ltd., CN=JPRS Domain Validation Authority - G2
         118029 C=GB, ST=Greater Manchester, L=Salford, O=Sectigo Limited, CN=Sectigo ECC Domain Validation Secure Server CA
         109435 C=GB, ST=Berkshire, L=Newbury, O=My Company Ltd
         108309 C=US, ST=Washington, L=Redmond, O=Microsoft Corporation, OU=Microsoft IT, CN=Microsoft IT TLS CA 2
         108016 C=US, O=GeoTrust Inc., CN=RapidSSL SHA256 CA - G3
         107719 C=--, ST=SomeState, L=SomeCity, O=SomeOrganization, OU=SomeOrganizationalUnit, CN=ns546485.ip-158-69-252.net, emailAddress=root@ns546485.ip-158-69-252.net
         106164 C=US, ST=DE, L=Wilmington, O=Corporation Service Company, CN=Trusted Secure Certificate Authority DV
         104634 CN=localhost
        
    In the zgrab schema they are `.data.tls.server_certificates.certificate.parsed.issuer_dn` , and you can reproduce the results with `zcat 2019-08-01-ssl-*.gz | parallel --pipe jq -r .data.tls.server_certificates.certificate.parsed.issuer_dn | sort | uniq -c`.

Let's Encrypt certs expire after 3 months, which pushes a regular update cycle, but there are still a number of ancient security practices around the web today.

## Almost 3 million domains connected with RC4 or 3DES

Of the hundred and sixty million connections, over a hundred and fifty million connections used Elliptic-Curve Diffie Hellmann and AES. The next most popular cipher suite was RSA with RC4, and almost 1.8% of connections used [RC4](https://en.wikipedia.org/wiki/RC4#Biased_outputs_of_the_RC4) or [3DES](https://en.wikipedia.org/wiki/Triple_DES#Security), with DES on half a dozen domains![^cipher_suite]

| 120457325 | TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 |
|  16750820 | TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256 |
|  13808304 | TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA |
|   2393679 | TLS_RSA_WITH_RC4_128_SHA |
|   1768423 | TLS_RSA_WITH_AES_256_CBC_SHA |
|   1653084 | TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA |
|   1397638 | TLS_RSA_WITH_AES_128_CBC_SHA |
|    373383 | TLS_ECDHE_RSA_WITH_RC4_128_SHA |
|    157929 | TLS_RSA_WITH_3DES_EDE_CBC_SHA |
|     17663 | TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA |
|      4041 | TLS_ECDHE_ECDSA_WITH_RC4_128_SHA |
|      2794 | TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA |
|       458 | TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA |
|       205 | TLS_RSA_WITH_RC4_128_MD5 |
|       115 | TLS_DH_RSA_WITH_AES_128_CBC_SHA |
|        28 | unknown |
|         6 | TLS_RSA_WITH_DES_CBC_SHA |
|         1 | TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 |

Note that the latest Chrome cannot load [RC4](https://rc4.badssl.com/) but it does load [3DES](https://3des.badssl.com/). (Thanks, `badssl.com`!)

[^cipher_suite]: `zcat 2019-08-01-ssl-*.gz | parallel --pipe jq -r .data.tls.server_hello.cipher_suite.name | sort | uniq -c`

## Over 4 million domains are using outdated TLS

By default, `go`'s TLS package doesn't use TLS 1.3, and it seems like the dataset was run with a zgrab that doesn't use TLS 1.3 (perhaps this is worth updating for the next run). Most domains' servers were using TLS 1.2, the next latest, but over 4 million were using TLS 1.0.[^tls_version]

| 154500876 | TLSv1.2 |
|   4263887 | TLSv1.0 |
|     19352 | TLSv1.1 |
|      1781 | SSLv3 |

Currently, [TLS 1.0](https://tls-v1-0.badssl.com:1010/) is still allowed in Chrome.

[^tls_version]: `zcat 2019-08-01-ssl-*.gz | parallel --pipe jq -r .data.tls.server_hello.version.name | sort | uniq -c`

## Hundreds of thousands of domains' certs expire after 2099

[Current SSL cert lifetime best practices](https://letsencrypt.org/2015/11/09/why-90-days.html) put lifetimes at 90 days.

But best practices do not forbid _alternative practices!_

![bristlecone pines from wikipedia, probably older than julius caesar himself](/assets/bristlecone.jpg)
Certs are in the wild with millenium-scale lifetimes, like these bristlecone pines.
<br><sup>(Rick Goldwaser from Flagstaff, AZ, USA [<a href="https://creativecommons.org/licenses/by/2.0">CC BY 2.0</a>], <a href="https://commons.wikimedia.org/wiki/File:Gnarly_Bristlecone_Pine.jpg">via Wikimedia Commons</a>)</sup>

### Thousands of certs served expire after the year 3000

Over 3K certs served don't expire this millenium. Over 8K certs expire after 2200. Over 200K certs expire after 2100. (Over 1.5M expire in the 2040s alone!)

Over a hundred thousand certs alone expire in 2117, and over a thousand expire in 3017. Perhaps something in 2017 inspired confidence in long-lived certs?

### Millions of certs served have expired

Almost 1.6M domains had a cert that had recently expired (in July, the month of the scan). Almost 3.7M domains had a cert that expired in 2019 (the year of the scan). Over 9.6M domains had a cert that expired in the 2010s!

### Hundreds of certs served are not yet valid

And what's more, over a hundred thousand certs expire before their validity date!

## Try this at home

Let me know what you think! Analyze this dataset and share your new findings!


----

