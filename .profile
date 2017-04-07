########################################################################
#
# ~/.profile
#
# This file is read by interactive login shells and non-interactive
# shells with the -l/--login option, and also when bash/ksh is invoked
# with the name 'sh'.
#
# And now for a tale of woe.
#
# The big not-so-secret is that there is apparently no way to tell the
# path (dirname(1)) of a sourced file, since sourcing a file does not
# invoke a sub-shell.  This limits the ability of any sourced file to
# call, source, or otherwise utilize relative paths.  This makes testing
# difficult, since all paths are hard-coded to be relative to the user's
# home directory.
#
# In other words, when testing changes in this file or any file in the
# .rc/ directory, make sure you make the change to the "real" file as
# well, not the one in the VCS repository, because that's the one that
# will actually be sourced.
########################################################################

# Uncomment this line to get some more detailed runtime logging.
#RC_VERBOSE=1

RC_FILENAME=".profile"
RC_PATH="${HOME}/.rc"

# Get rc_* functions as early as possible.
. "${RC_PATH}/rc_utils"

rc_log "starting up"

# Hand control over to .rc/rc.
case "${0#-}" in
    bash)
        [[ -r "${HOME}/.rc/rc" ]] && . "${HOME}/.rc/rc"
        ;;
    ksh*)
        # As per ksh(1): "If the ENV parameter is set when an
        # interactive shell starts (or, in the case of login shells,
        # after any profiles are processed), its value is subjected to
        # parameter, command, arithmetic, and tilde (`~') substitution
        # and the resulting file (if any) is read and executed."
        [[ -f "${HOME}/.rc/rc" ]] && export ENV="${HOME}/.rc/rc"
        ;;
esac
