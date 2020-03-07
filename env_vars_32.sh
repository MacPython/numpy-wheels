# Environment variables for 32-bit build.
# The important difference from the 64-bit build is `-msse2` to
# compile sse loops for ufuncs.
OPENBLAS_VERSION="v0.3.7"
MACOSX_DEPLOYMENT_TARGET=10.9
CFLAGS="-msse2 -std=c99 -fno-strict-aliasing"
