#!/bin/sh
# This script installs and verifies pkgsrc for OSX.

BOOTSTRAP_FILE=bootstrap-2015Q3-x86_64.tar.gz
SHASUM=c150c0db1daddb4ec49592a7563c2838760bfb8b
######################################################

echo "==> Installing pkgsrc"

. funcs.sh

PKGSRC_SITE=https://pkgsrc.joyent.com/packages/Darwin/bootstrap/
DOWNLOADER=$(downloader)
if [ -z "$DOWNLOADER" ]; then
    echo "no valid HTTP downloader found"
    exit
fi

TMPDIR=$(mktemp -d)
if [ -z "$TMPDIR" ]; then
    echo "temp dir creation failed"
    exit
fi
cd "$TMPDIR"

trap "rm -rf $TMPDIR" EXIT

# Download 64-bit bootstrap kit
echo "==> Downloading $BOOTSTRAP_FILE"
$DOWNLOADER "${PKGSRC_SITE}${BOOTSTRAP_FILE}" > $BOOTSTRAP_FILE

# Verify the download. Kind of hacky right now.
echo "==> Verifying SHA hash"
echo "$SHASUM  $BOOTSTRAP_FILE" > cksumfile
shasum -c cksumfile 
[[ $? == 0 ]] || exit

# Verify PGP signature (optional, requires gpg to be installed)
if [ -n "$(command -v gpg)" ]; then
    echo "==> Verifying GPG signature"
    $DOWNLOADER "${PKGSRC_SITE}${BOOTSTRAP_FILE}.asc" > ${BOOTSTRAP_FILE}.asc
    gpg --recv-keys 0xDE817B8E
    gpg --verify ${BOOTSTRAP_FILE}{.asc,}
    [[ $? == 0 ]] || exit
fi

# Install bootstrap kit to /opt/pkg
echo "==> Installing $BOOTSTRAP_FILE"
sudo tar -zxpf $BOOTSTRAP_FILE -C /
[[ $? == 0 ]] || exit

# Fetch package repository information
sudo rm -rf /var/db/pkgin
sudo /opt/pkg/bin/pkgin -y update

echo "pkgsrc installation finished.  Please add /opt/pkg/bin to your PATH."
