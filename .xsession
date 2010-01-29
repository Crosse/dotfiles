eval "`gnome-keyring-daemon`"
export GNOME_KEYRING_PID
export GNOME_KEYRING_SOCKET
export SSH_AUTH_SOCK

exec /usr/local/bin/startfluxbox
