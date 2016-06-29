# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]
OPENBLAS_VERSION=0.2.18
source gfortran-install/gfortran_utils.sh

function build_wheel {
    # Only use openblas for manylinux
    if [ -z "$IS_OSX" ]; then
        build_libs $PLAT
    fi
    build_pip_wheel $@
}

function build_libs {
    local plat=${1:-$PLAT}
    local tar_path=$(abspath $(get_gf_lib "openblas-${OPENBLAS_VERSION}" "$plat"))
    (cd / && tar zxf $tar_path)
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    test_cmd="import sys; import numpy; \
        sys.exit(not numpy.test('full').wasSuccessful())"
    if [ -n "$IS_OSX" ]; then  # Test both architectures on OSX
        # Skip f2py tests for 32-bit
        arch -i386 python -c "import sys; import numpy; \
            sys.exit(not numpy.test('full', \
            extra_argv=['-e', 'f2py']).wasSuccessful())"
        arch -x86_64 python -c "$test_cmd"
    else
        python -c "$test_cmd"
    fi
    # Show BLAS / LAPACK used
    python -c 'import numpy; numpy.show_config()'
}
