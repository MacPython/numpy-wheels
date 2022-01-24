REM set Visual Studio 2017 toolchain (v141)
IF [%1] == [] GOTO NoArgErr
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvars%1.bat" -vcvars_ver=14.16
set DISTUTILS_USE_SDK=1
goto:eof

:NoArgErr
    echo "No input bitness argument"
    exit 1
