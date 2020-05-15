function setup_test_venv {
    # Create a new empty venv dedicated to testing for non-Linux platforms. On
    # Linux the tests are run in a Docker container.
    if [ $(uname) != "Linux" ]; then
        if type -t deactivate ; then deactivate; fi
        $PYTHON_EXE -m venv test_venv
        if [ $(uname) == "Darwin" ]; then
            source test_venv/bin/activate
        else
            mkdir -p test_venv/libs
            source test_venv/Scripts/activate
        fi
        # Note: the idiom "python -m pip install ..." is necessary to upgrade
        # pip itself on Windows. Otherwise one would get a permission error on
        # pip.exe.
        PYTHON_EXE=python
        PIP_CMD="$PYTHON_EXE -m pip"
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

function rename_wheel {
    # Call with a name like numpy-1.19.0.dev0+58dbafa-cp37-cp37m-linux_x86_64.whl

    # Add a date after the dev0+ and before the hash in yyymmddHHMMSS format
    # so pip will pick up the newest build. Try a little to make sure
    # - the first part ends with 'dev0+'
    # - the second part starts with a lower case alphanumeric then a '-'
    # if those conditions are not met, the name will be returned as-is

    newname=$(echo "$1" | sed "s/\(.*dev0+\)\([a-z0-9]*-.*\)/\1$(date '+%Y%m%d%H%M%S_')\2/")
    echo rename_wheel "$1" to "$newname" using "$(date '+%Y%m%d%H%M%S_')"
    if [ "$newname" != "$1" ]; then
        mv $1 $newname
    fi
}

# Work around bug in multibuild
if [ ! -o PIP_CMD ]; then PIP_CMD="$PYTHON_EXE -m pip"; fi
