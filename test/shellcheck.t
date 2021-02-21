#!/usr/bin/env bash
# shellcheck disable=1091,2046,2207

source test/setup

use Test::More

command -v shellcheck >/dev/null ||
  plan skip_all "The 'shellcheck' utility is not installed"
[[ $(shellcheck --version) =~ 0\.7\.1 ]] ||
  plan skip_all "This test wants shellcheck version 0.7.1"

shell_files=($(
  find $(git rev-parse --show-toplevel) \
    -name '.rc' -print -o \
    -name '*.bash' -print -o \
    -type f -exec awk \
      '/^#!.*bash/{print FILENAME}; {nextfile}' {} + |
  grep -v '/\.test-more-bash/'
))

skips=(
  # We want to keep these 2 here always:
  SC1090  # Can't follow non-constant source. Use a directive to specify location.
  SC1091  # Not following: bash+ was not specified as input (see shellcheck -x).
)
skip=$(IFS=,; echo "${skips[*]}")

for file in "${shell_files[@]}"; do
  [[ $file == *swp ]] && continue
  is "$(shellcheck -e "$skip" "$file")" "" \
    "The shell file '$file' passes shellcheck"
done

done_testing

# vim: set ft=sh:
