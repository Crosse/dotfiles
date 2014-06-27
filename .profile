########################################################################
#
# Copyright (c) 2010-2014 Seth Wright (seth@crosse.org)
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
# AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
# DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
# PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
# TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
########################################################################
#
# ~/.profile
#
# This file is read by interactive login shells and non-interactive
# shells with the -l/--login option, and also when bash/ksh is invoked
# with the name 'sh'.
########################################################################

RC_VERBOSE=1

[[ -n "$RC_VERBOSE" ]] && echo "running .profile"

# Some shell-specific things.
if [ ${0#-} == "ksh" ]; then
    # As per ksh(1): "If the ENV parameter is set when an
    # interactive shell starts (or, in the case of login shells,
    # after any profiles are processed), its value is subjected to
    # parameter, command, arithmetic, and tilde (`~') substitution
    # and the resulting file (if any) is read and executed."
    [[ -f "${HOME}/.kshrc" ]] && export ENV="${HOME}/.kshrc"
fi
