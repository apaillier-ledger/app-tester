FROM alpine:3.15

RUN apk add python3 \
            py3-qt5 \
            tesseract-ocr \
            qemu-arm \
            libusb

ARG QEMU_BIN=qemu-arm

# -static version is not available in Alpine repositories
RUN ln -s "$QEMU_BIN" $(dirname $(which "$QEMU_BIN"))/$QEMU_BIN-static

ARG PYTHON_BUILD_DEPS=gcc,python3-dev,musl-dev,libusb-dev,eudev-dev,linux-headers

RUN apk add $(echo -n "$PYTHON_BUILD_DEPS" | tr , ' ')

ARG BRANCH_NAME=develop
ARG ZIP_NAME=repo.zip
ARG BIN_ZIP=boilerplate_binaries.zip

COPY $BIN_ZIP /tmp/

RUN cd /tmp && \
    wget "https://github.com/LedgerHQ/ragger/archive/refs/heads/$BRANCH_NAME.zip" -O "$ZIP_NAME" && \
    unzip "$ZIP_NAME" && \
    rm -f "$ZIP_NAME"

RUN python3 -m ensurepip --upgrade && pip3 install --upgrade pip && pip3 install wheel

RUN cd "/tmp/ragger-$(echo -n "$BRANCH_NAME" | tr / -)" && \
    mkdir .git && \
    pip3 install --extra-index-url https://test.pypi.org/simple/ .[tests,all_backends] &&\
    cd build && \
    unzip "/tmp/$BIN_ZIP" && \
    rm -f "/tmp/$BIN_ZIP"

RUN apk del $(echo -n "$PYTHON_BUILD_DEPS" | tr , ' ')
