#!/usr/bin/env bash
# Environment variables for 32-bit build.
# The important difference from the 64-bit build is `-msse2` to
# compile sse loops for ufuncs.
set -x
MACOSX_DEPLOYMENT_TARGET=10.9
CFLAGS="-msse2 -std=c99 -fno-strict-aliasing"
# Macos's linker doesn't support stripping symbols
if [ "$(uname)" != "Darwin" ]; then
    LDFLAGS="-Wl,--strip-debug"
    # make sure that LDFLAGS is exposed to child processes,
    # since current version of manybuild only export CFLAGS, CPPFLAGS and FFLAGS
    export LDFLAGS="$LDFLAGS"
    # override the default stripping flags, since we only override CFLAGS and
    # the current version of manybuild pass "-strip-all" to CPPFLAGS and FFLAGS
    STRIP_FLAGS=""
fi
