#!/usr/bin/env bash
# shellcheck disable=1090,2154,2217

source "$(dirname "${BASH_SOURCE[0]}")"/setup || exit

set -- -b --yyy=okie
getopt "$@" <<<"$spec1"
is "$option_bar" "true" "Short flag option is set correct"
is "${option_quux-}" "" "Value option is empty by default"
is "$option_xxx" "false" "Long flag option has default correct"
is "$option_yyy" "okie" "Long value option works correctly"

done_testing 4

# vim: ft=sh:
