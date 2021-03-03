# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]
# See env_vars.sh for extra environment variables
if [ $(uname) == "Linux" ]; then IS_LINUX=1; fi
source gfortran-install/gfortran_utils.sh

function _build_wheel {
    build_libs
    build_bdist_wheel $@
}

function build_wheel {
    if [ -n "$IS_OSX" ]; then
        install_gfortran
    fi
    echo gcc --version
    echo `gcc --version`
    # Fix version error for development wheels by using bdist_wheel
    wrap_wheel_builder _build_wheel $@
}

function install_delocate {
    check_pip
    $PIP_CMD install git+https://github.com/isuruf/delocate.git@loader_path
}

function build_libs {
    # setuptools v49.2.0 is broken
    $PYTHON_EXE -mpip install --upgrade "setuptools<49.2.0"
    # Use the same incantation as numpy/tools/travis-before-install.sh to
    # download and un-tar the openblas libraries. The python call returns
    # the un-tar root directory, then the files are copied into /usr/local.
    # Could utilize a site.cfg instead to prevent the copy.
    $PYTHON_EXE -mpip install urllib3
    $PYTHON_EXE -c"import platform; print('platform.uname().machine', platform.uname().machine)"
    basedir=$($PYTHON_EXE numpy/tools/openblas_support.py)
    mkdir -p $BUILD_PREFIX/lib
    mkdir -p $BUILD_PREFIX/include
    $use_sudo cp -r $basedir/lib/* $BUILD_PREFIX/lib
    $use_sudo cp $basedir/include/* $BUILD_PREFIX/include
    export OPENBLAS=$BUILD_PREFIX
}

function get_test_cmd {
    local extra_argv=${1:-$EXTRA_ARGV}
    echo "import sys; import numpy; \
        sys.exit(not numpy.test('full', \
        extra_argv=['-vv', ${extra_argv}]))"
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    if [ -n "$IS_LINUX" ]; then
        apt-get -y update && apt-get install -y gfortran
    fi
    $PYTHON_EXE -c "$(get_test_cmd)"
    # Check bundled license file
    $PYTHON_EXE ../check_license.py
    # Test BLAS / LAPACK used
    if [ -n "$IS_LINUX" -o -n "$IS_OSX" ]; then
        $PYTHON_EXE ../numpy/tools/openblas_support.py --check_version
    fi
    $PYTHON_EXE -c 'import numpy; numpy.show_config()'
}
