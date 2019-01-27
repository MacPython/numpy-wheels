# Environment variables for build
OPENBLAS_VERSION="v0.3.3-186-g701ea883"
MACOSX_DEPLOYMENT_TARGET=10.9
if [ "$PLAT"  == "i686" ]; then
    CFLAGS="-std=c99 -O2 -fno-strict-aliasing"
else
    CFLAGS="-std=c99 -fno-strict-aliasing"
fi
