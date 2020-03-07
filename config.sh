# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]
# See env_vars.sh for extra environment variables
source gfortran-install/gfortran_utils.sh

function build_wheel {
    local lib_plat=$PLAT
    if [ -n "$IS_OSX" ]; then
        install_gfortran
    else
        # For manylinux2010 builds with manylinux1 openblas builds
        $use_sudo yum install -y libgfortran-4.4.7
    fi
    build_libs $lib_plat
    # Fix version error for development wheels by using bdist_wheel
    build_bdist_wheel $@
}

function build_libs {
    # Use the same incantation as numpy/tools/travis-before-install.sh to
    # download and un-tar the openblas libraries. The python call returns
    # the un-tar root directory, then the files are copied into /usr/local.
    # Could utilize a site.cfg instead to prevent the copy.
    python -mpip install urllib3
    basedir=$(python numpy/tools/openblas_support.py)
    $use_sudo cp -r $basedir/lib/* /usr/local/lib
    $use_sudo cp $basedir/include/* /usr/local/include
}

function get_test_cmd {
    local extra_argv=${1:-$EXTRA_ARGV}
    echo "import sys; import numpy; \
        sys.exit(not numpy.test('full', \
        extra_argv=['-vv', ${extra_argv}]))"
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    if [ -z "$IS_OSX" ]; then
        apt-get -y update && apt-get install -y gfortran
    fi
    python -c "$(get_test_cmd)"
    # Check bundled license file
    python ../check_license.py
    # Show BLAS / LAPACK used. Since this uses a wheel we cannot use
    # tools/openblas_config.py; tools is not part of what is shipped
    python -c 'import numpy; numpy.show_config()'
}
