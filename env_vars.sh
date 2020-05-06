#!/usr/bin/env bash
# Environment variables for build
OPENBLAS_VERSION="v0.3.7"
MACOSX_DEPLOYMENT_TARGET=10.9
CFLAGS="-std=c99 -fno-strict-aliasing"
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
