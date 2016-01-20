#!/bin/sh

downloader() {
    # Prefer curl, then wget
    case "$(uname)" in
        OpenBSD)
            echo "ftp"
            ;;
        Linux|Darwin)
            if [ "$(command -v curl)" ]; then
                echo "curl -Lso-"
            elif [ "$(command -v wget)" ]; then
                echo "wget -qO-"
            fi
            ;;
    esac
}
