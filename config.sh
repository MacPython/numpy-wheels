# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    if [ -z "$IS_OSX" ]; then
        build_openblas
    fi
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
