---
layout: default
title: Checking ISO files integrity
categories: Sysadmin Linux
parent: Linux
grand_parent: Cheatsheets
---

# {{ page.title }} 

## Checking Ubuntu ISO using repository GPG Keys (secure)

This method verifies the hashes published by Canonical are actually authentic. 
Unlike performing a quick checksum, the SHA256SUMS file is signed and only Ubuntu’s key can unlock the file to reveal the checksums exactly as Ubuntu published them.

1. Download a copy of the SHA256SUMS and SHA256SUMS.gpg files from Canonical’s CD Images server for that particular version.

2. Install the Ubuntu Keyring. This may already be present on your system.
```
sudo apt-get install ubuntu-keyring
```

3. Verify the keyring.
```
gpgv --keyring=/usr/share/keyrings/ubuntu-archive-keyring.gpg SHA256SUMS.gpg SHA256SUMS
```

4. Verify the checksum of the downloaded image.
```
grep ubuntu-mate-18.04-desktop-amd64.iso SHA256SUMS | sha256sum --check
```

5. If you see “OK”, the image is in good condition.
```
ubuntu-mate-18.04-desktop-amd64.iso: OK
```


