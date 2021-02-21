getopt-bash
===========

Declarative getopt (long) parser


# Synopsis

```bash
#!/bin/bash

source getopt.bash

name=$(basename $0)
set -- getopt "$@" <<<"\
  $name <options...>

See 'man $name' for more help.

Options:
--
b,bar       Bar bar bar
q,quux=     Quux quux

xxx         Xxx xxx
yyy=        Yyy yyy

help        Show help
version     Print $name version
"

if $option_bar || $option_xxx; then
  echo 'Options:'
  echo "quux = ${option_quux-}"
  echo "yyy = ${option_yyy-}"
  echo 'Arguments:'
  printf "- %s\n" "$@"
fi
```


# Description

Git has a little known, but very cool getopt parser built in.
The Git command is:
```bash
git rev-parse --parseopt <command-line-args> \
  <<<"<special-format-getopt-spec-text>"
```

You pipe in a special format that looks like a help text describing the
command.
If you ask for `--help` (or the parser fails to parse the options), it actually
will print a slightly reformatted version of that spec.

This library makes the Git facility even more powerful and easy to use.

# Parlance

* options (or opts)

  Options are the parameters like `-h`, `--help`, `-f <file>`, `--file <file>`
  or `--file=<file>.
  Note that option names are case insensitive.
  ie `-f` and `-F` are diffent options.

* arguments (or args)

  Arguments are the (zero or more) strings that (usually) follow the options.

* long option

  An option of the form `--name`.
  Two dashes and two or more letters in the name.
  An `=` or a space may be used to separate the option from its value.
  ie `--file=abc.txt` or `--file abc.txt`.

* short option

  An option of the form `-n`.
  A single dash and a single character for the name.
  If the option has a value, it is separated by a space: `-f abc.txt`.

* flag option

  Flag options never have a value parameter.
  The values returned by getopt-bash are `false` (default if the option is not
  present) and `true` if the option *is* present.

* value option

  Value options always have a value parameter.
  This getopt-bash library returns the value specified or the empty string if
  it is not present in the parsed parameters.

* dual option

  A dual option can be used alone like a flag option, or with a value.


# Usage

The `getopt-bash` library provides a single file `lib/getopt.bash`.
If you `source getopt.bash` it provides a single function `getopt`.
The `getopt` function expects a specially formatted spec string in its STDIN
and the arguments you want to parse, passed in as arguments to the function.

It also checks for a special array variable called `getopt` (yes, you can have
a variable and a function with the same name in Bash) that contains a number of
configuration option pairs (descibed below).

The function will (by default) set each option in a variable called
`option_<option-name>` and will print any arguments to stdout.

`_`

Here's an example:
```bash
getopt=(
  default-args  --help
  debug-opt     DEBUG
  args-var      my_args
)
getopt "$@" <<<"$spec_string"
echo "The '--foo' option is '$option_foo' and the args are '${my_args[*]}'"
```

NOTE: Bash has a builtin `getopt` command that doesn't do nearly as much.
If you need to use the builtin in combination with this library, just use this
command: `builtin getopt ...` for the builtin version.

## The getopt Spec String Format

To get good at using getopt-bash you should run `git help rev-parse` search for
`^PARSEOPT` and read that entire section.
The getopt-bash function uses `git rev-parse --parseopt` under the hood, but
does a bunch of extra pre-processing and post-processing to make things really
nice and simple.

The options section of the spec has these various combinations:
```
The options with `string` and `number` are enforced by getopt-bash
--
f,file=         Description of a value option (both short and long)
help            Description of a flag option (long only)
Q?              Description of a dual option (short only)

color=string    Value must be a string
verbose?number  Value (if present) must be a number
```

The getopt-bash library adds some additional features to the spec options
syntax:
```
input=+         This option is required
size=+number    Required and must be number
style=@         May be used more than once
color=+@string  Required, 1 or more times, must be string
```

In `git rev-parse`, there are 4 flag characters: '* = ? !`.
The getopt-bash library adds:

* `+`

  Option is required.
  This only makes sense for value options.

* `@`

  Option may be specified multiple times.
  The getopt function puts the results in a Bash array variable.

In `git rev-parse` you can specify a hint word to indicate in the help text
what type of value (number, string, etc) is expected for a value option.
The hint is not enforced.

By default, getopt-bash will enforce the following hints:

* `string` or `str`

  Value should be a string.

* `number` or `num` or `int`

  Value should be a number.

* `1..10`

  Value should be a number in the range 1-10.

* `file`

  Value should be a file that exists.

* `dir`

  Value should be a directory the exists.

* `path`

  Value should be the path of a file or directory that exists.


## Configuration

The `getopt` function has sensible defaults but it is also highly configurable.

* `opts-pre`


# License and Copyright

Copyright 2020-2021. Ingy döt Net <ingy@ingy.net>.

getopt-bash is released under the MIT license.

See the file License for more details.
