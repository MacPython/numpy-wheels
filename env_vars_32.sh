# Environment variables for 32-bit build.
# The important difference from the 64-bit build is `-msse2` to
# compile sse loops for ufuncs.
set -x
OPENBLAS_VERSION="v0.3.7"
MACOSX_DEPLOYMENT_TARGET=10.9
# Causes failure for pre-1.19 in np.reciprocal
# CFLAGS="-msse2 -std=c99 -fno-strict-aliasing"
CFLAGS="-std=c99 -fno-strict-aliasing"
