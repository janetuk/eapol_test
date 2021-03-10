## Based on instructions from https://wiki.geant.org/display/H2eduroam/Testing+with+eapol_test

FROM ubuntu AS build

LABEL maintainer "Matthew Slowe <matthew.slowe@jisc.ac.uk>"
LABEL description "Cross-compiler utility for eapol_test targetting Windows (x86_64-w64-mingw32)"

ENV PREFIX=x86_64-w64-mingw32

ENV CC=$PREFIX-gcc \
    CXX=$PREFIX-g++ \
    CPP=$PREFIX-cpp \
    AR=$PREFIX-ar \
    AS=$PREFIX-as \
    NM=$PREFIX-nm \
    WINDRES=$PREFIX-windres \
    RANLIB=$PREFIX-ranlib \
    ADDR2LINE=$PREFIX-addr2line \
    DLLTOOL=$PREFIX-dlltool \
    DLLWRAP=$PREFIX-dllwrap \
    ELFEDIT=$PREFIX-elfedit \
    OBJCOPY=$PREFIX-objcopy \
    OBJDUMP=$PREFIX-objdump \
    READELF=$PREFIX-readelf \
    SIZE=$PREFIX-size \
    STRINGS=$PREFIX-strings \
    STRIP=$PREFIX-strip \
    WINDMC=$PREFIX-windmc \
    GCOV=$PREFIX-gcov \
    PATH="/usr/x86_64-w64-mingw32/bin:$PATH"

RUN apt-get update && apt-get install -y mingw-w64 build-essential xz-utils wget

WORKDIR /tmp

RUN set -ex && \
    wget https://raw.githubusercontent.com/janetuk/eapol_test/main/eapol_test.c.patch && \
    wget https://raw.githubusercontent.com/janetuk/eapol_test/main/eapol_test.config && \
    wget https://github.com/libtom/libtommath/releases/download/v1.2.0/ltm-1.2.0.tar.xz && \
    wget https://w1.fi/releases/wpa_supplicant-2.9.tar.gz

RUN set -ex && \
    tar xf ltm-1.2.0.tar.xz && \
    tar xfv wpa_supplicant-2.9.tar.gz && \
    sed 's~LTM_PATH=.*~LTM_PATH=/tmp/libtommath-1.2.0~' eapol_test.config >wpa_supplicant-2.9/wpa_supplicant/.config && \
    patch wpa_supplicant-2.9/wpa_supplicant/eapol_test.c <eapol_test.c.patch

WORKDIR /tmp/libtommath-1.2.0
RUN make

WORKDIR /tmp/wpa_supplicant-2.9/wpa_supplicant
ENV CFLAGS=" -Wno-error=pointer-to-int-cast -MMD -O2 -g -w"
RUN make eapol_test

### End build

FROM busybox
COPY --from=build /tmp/wpa_supplicant-2.9/wpa_supplicant/eapol_test.exe /

