function setup_test_venv {
    # Create a new empty venv dedicated to testing for non-Linux platforms. On
    # Linux the tests are run in a Docker container.
    if [ $(uname) != "Linux" ]; then
        if type -t deactivate ; then deactivate; fi
        $PYTHON_EXE -m venv test_venv
        if [ $(uname) == "Darwin" ]; then
            source test_venv/bin/activate
        else
            source test_venv/Scripts/activate
        fi
        # Note: the idiom "python -m pip install ..." is necessary to upgrade
        # pip itself on Windows. Otherwise one would get a permission error on
        # pip.exe.
        python -m pip install --upgrade pip wheel
        if [ "$TEST_DEPENDS" != "" ]; then
            pip install $TEST_DEPENDS
        fi
    fi
}

function teardown_test_venv {
    if [ $(uname) != "Linux" ]; then
        if type -t deactivate ; then deactivate; fi
        if [ $(uname) == "Darwin" ]; then
            source venv/bin/activate
        fi
    fi
} 
# Work around bug in multibuild
if [ ! -o PIP_CMD ]; then PIP_CMD="$PYTHON_EXE -mpip"; fi
