# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]
OPENBLAS_VERSION=0.2.18
source gfortran-install/gfortran_utils.sh

function build_wheel {
    if [ -z "$IS_OSX" ]; then
        build_libs $PLAT
        build_pip_wheel $@
    else
        build_osx_wheel $@
    fi
}

function build_libs {
    local plat=${1:-$PLAT}
    local tar_path=$(abspath $(get_gf_lib "openblas-${OPENBLAS_VERSION}" "$plat"))
    (cd / && tar zxf $tar_path)
}

function set_arch {
    local arch=$1
    export CC="clang $arch"
    export CXX="clang++ $arch"
    export CFLAGS="$arch"
    export FFLAGS="$arch"
    export FARCH="$arch"
    export LDFLAGS="$arch"
}

function build_osx_wheel {
    # Build dual arch wheel
    local repo_dir=${1:-$REPO_DIR}
    local wheelhouse=$(abspath ${WHEEL_SDIR:-wheelhouse})
    local py_ld_flags="-Wall -undefined dynamic_lookup -bundle"
    local wheelhouse32=${wheelhouse}32

    install_gfortran
    # 32-bit wheel
    local arch="-m32"
    set_arch $arch
    # Build libraries
    build_libs i686
    # Build wheel
    mkdir -p $wheelhouse32
    export LDSHARED="$CC $py_ld_flags"
    export LDFLAGS="$arch $py_ld_flags"
    build_pip_wheel "$repo_dir"
    mv ${wheelhouse}/*whl $wheelhouse32
    # 64-bit wheel
    local arch="-m64"
    set_arch $arch
    build_libs x86_64
    # Build wheel
    export LDSHARED="$CC $py_ld_flags"
    export LDFLAGS="$arch $py_ld_flags"
    build_pip_wheel "$repo_dir"
    # Fuse into dual arch wheel(s)
    for whl in ${wheelhouse}/*.whl; do
        delocate-fuse "$whl" "${wheelhouse32}/$(basename $whl)"
    done
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
    # Show BLAS / LAPACK used
    python -c 'import numpy; numpy.show_config()'
}
