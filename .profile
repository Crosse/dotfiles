# .profile
#
# This file is read by interactive login shells
# and non-interactive shells with the --login option,
# and also when bash is invoked with the name 'sh'.

PATH=`echo $PATH | sed -e "s/\(.*\)\/usr\/local\/bin:\(.*\)/\/usr\/local\/bin:\1\2/"`
PATH=$PATH:$HOME/bin

case $(uname) in
    "OpenBSD")
        PATH=$PATH:/usr/games
        export PKG_PATH=http://mirrors.24-7-solutions.net/pub/OpenBSD/snapshots/packages/`arch -s`/
    ;;

    "Darwin")
        # Added to support git on Mac OSX.
        if [ -d /usr/local/git/bin ]; then
            PATH=$PATH:/usr/local/git/bin
        fi
    ;;

esac

# ccache stuff, if ever needed.
export CCACHE_DIR=${HOME}/.ccache
#export CCACHE_LOGFILE=${CCACHE_DIR}/ccache.log

case ${0#-} in
    "bash")
        if [ -f ${HOME}/.kshrc ]; then
            . ${HOME}/.kshrc
        fi
    ;;

    "ksh")
        export ENV=${HOME}/.kshrc
    ;;
esac

export PATH HOME TERM
