# eapol_test (on Windows)

This repository contains a patch, a configuration file and instructions to build eapol_test on Linux for Windows. The patch may eventually disappear once [@jmalinen](https://w1.fi/) accepts it into the wpa_supplicant codebase.

The eapol_test.config file replaces the .config file in the wpa_supplicant directory. It is built using an internal TLS implementation and will require [libtommath](https://github.com/libtom/libtommath).

Build instructions can be found here: 
  https://wiki.geant.org/display/H2eduroam/Testing+with+eapol_test

A binary download (signed by Jisc) can be found under the releases or here:
  https://www.dropbox.com/s/9nmw4r7b5jr263d/eapol_test.exe?dl=1
