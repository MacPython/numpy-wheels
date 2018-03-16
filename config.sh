# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]
OPENBLAS_VERSION="0.2.20-343-g2c7392f0"
source gfortran-install/gfortran_utils.sh

function build_wheel {
    # Only use openblas for manylinux
    if [ -z "$IS_OSX" ]; then
        build_libs $PLAT
    fi
    # Fix version error for development wheels by using bdist_wheel
    build_bdist_wheel $@
}

function build_libs {
    local plat=${1:-$PLAT}
    local tar_path=$(abspath $(get_gf_lib "openblas-${OPENBLAS_VERSION}" "$plat"))
    (cd / && tar zxf $tar_path)
}

function get_test_cmd {
    local extra_argv=${1:-$EXTRA_ARGV}
    echo "import sys; import numpy; \
        sys.exit(not numpy.test('full', \
        extra_argv=[${extra_argv}]).wasSuccessful())"
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    if [ -n "$IS_OSX" ]; then  # Test both architectures on OSX
        # Skip f2py tests for 32-bit
        arch -i386 python -c "$(get_test_cmd "'-e', 'f2py', $EXTRA_ARGV")"
        arch -x86_64 python -c "$(get_test_cmd)"
    else
        python -c "$(get_test_cmd)"
    fi
    # Check bundled license file
    python ../check_license.py
    # Show BLAS / LAPACK used
    python -c 'import numpy; numpy.show_config()'
}
