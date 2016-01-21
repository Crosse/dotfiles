#!/bin/sh

downloader() {
    # Prefer curl, then wget
    case "$(uname)" in
        OpenBSD)
            echo "ftp"
            ;;
        Linux|Darwin)
            if [ "$(command -v curl)" ]; then
                echo "curl -Lo-"
            elif [ "$(command -v wget)" ]; then
                echo "wget -O-"
            fi
            ;;
    esac
}
