#!/usr/bin/env python

import re, subprocess

def get_keyring_pass(account=None, server=None):
    cmd = ['/usr/bin/secret-tool', 'lookup']
    cmd.extend(['server', server])
    cmd.extend(['user', account])
    output = subprocess.check_output(cmd, stderr=subprocess.STDOUT)
    return output
