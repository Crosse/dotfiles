#!/usr/bin/env bash
# This script installs and verifies pkgsrc for OSX.

case $(uname) in
    Darwin)
        case $(sw_vers -productVersion) in
            10.15.*)
                BOOTSTRAP_TAR="bootstrap-macos14-trunk-x86_64-20200716.tar.gz"
                BOOTSTRAP_SHA="395be93bf6b3ca5fbe8f0b248f1f33181b8225fe"
                ;;
            11.*)
                BOOTSTRAP_TAR="bootstrap-macos11-trunk-x86_64-20201112.tar.gz"
                BOOTSTRAP_SHA="b3c0c4286a2770bf5e3caeaf3fb747cb9f1bc93c"
                ;;
        esac
        ;;
esac
######################################################

if [[ -z $BOOTSTRAP_TAR ]]; then
    echo "I don't know how to install pkgsrc on this platform!" 1>&2
    exit 1
fi

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
echo "==> Downloading $BOOTSTRAP_TAR"
$DOWNLOADER "${PKGSRC_SITE}${BOOTSTRAP_TAR}" > $BOOTSTRAP_TAR

# Verify the download. Kind of hacky right now.
echo "==> Verifying SHA hash"
echo "$BOOTSTRAP_SHA  $BOOTSTRAP_TAR" > cksumfile
shasum -c cksumfile
[[ $? == 0 ]] || exit

# Install bootstrap kit to /opt/pkg
echo "==> Installing $BOOTSTRAP_TAR"
sudo tar -zxpf $BOOTSTRAP_TAR -C /
[[ $? == 0 ]] || exit

# Fetch package repository information
sudo rm -rf /var/db/pkgin
sudo /opt/pkg/bin/pkgin -y update

echo "pkgsrc installation finished.  Please add /opt/pkg/bin to your PATH."
