# Environment variables for build
OPENBLAS_VERSION="v0.3.5-605-gc815b8fb"  # the 0.3.5 is misleading, this is 0.3.8dev
MACOSX_DEPLOYMENT_TARGET=10.9
# For verbosity: report where each command came from
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
set -x
