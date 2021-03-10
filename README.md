# eapol_test (on Windows)

This repository contains a patch, a configuration file and instructions to build eapol_test on Linux for Windows. The patch may eventually disappear once [@jmalinen](https://w1.fi/) accepts it into the wpa_supplicant codebase.

The eapol_test.config file replaces the .config file in the wpa_supplicant directory. It is built using an internal TLS implementation and will require [libtommath](https://github.com/libtom/libtommath).

Build instructions can be found here:
  https://wiki.geant.org/display/H2eduroam/Testing+with+eapol_test

A binary download (signed by Jisc) can be found under the releases or here:
  https://www.dropbox.com/s/9nmw4r7b5jr263d/eapol_test.exe?dl=1

## Building using Docker

Cross-compiling `eapol_test.exe` from Linux produces a usable binary but requires a considerable amount of work.

The `Dockerfile`, based on the Ubuntu base image can be used to automate this process. It's suitable for a Linux (or x86 macOS) build environment:

```bash
# 1. Build the container
docker build -t eapol_test .

# 2. Extract the compiled binary from the image
docker run --rm -v "${PWD}:/a" eapol_test cp /eapol_test.exe /a
```

At this point you should have a `eapol_test.exe` in the current working directory.

### Known issues
1. No version tracking
2. Produces an unsigned executable which may not be suitable for some environments
3. The Docker build cache is quite large (about 2G) and you may wish to `docker system prune` after the build is complete
