@@echo on
REM set Visual Studio toolchain given bitness, VS year and toolchain number.

REM Parts of this file copied from:
REM https://github.com/conda-forge/vc-feedstock/blob/7c0aa76218f369227d6a7fc78f981b100d68d50a/recipe/activate.bat
REM licensed as follows:
REM BSD-3-Clause
REM Copyright conda-forge contributors

IF [%1] == [] GOTO NoArgErr
set VS_BITS=%1
IF [%2] == [] GOTO NoArgErr
set VS_YEAR=%2
IF [%3] == [] GOTO NoArgErr
set VS_TOOLCHAIN=%3

REM Tools can come from any of Professional, Community, BuildTools or Enterprise install.
if not exist "%VSINSTALLDIR%" (
set "VSINSTALLDIR=%ProgramFiles(x86)%\Microsoft Visual Studio\%VS_YEAR%\Professional\"
)
if not exist "%VSINSTALLDIR%" (
set "VSINSTALLDIR=%ProgramFiles(x86)%\Microsoft Visual Studio\%VS_YEAR%\Community\"
)
if not exist "%VSINSTALLDIR%" (
set "VSINSTALLDIR=%ProgramFiles(x86)%\Microsoft Visual Studio\%VS_YEAR%\BuildTools\"
)
if not exist "%VSINSTALLDIR%" (
set "VSINSTALLDIR=%ProgramFiles(x86)%\Microsoft Visual Studio\%VS_YEAR%\Enterprise\"
)

REM Discover the latest Windows SDK available.
call :GetWin10SdkDir
:: dir /ON here is sorting the list of folders, such that we use the latest one that we have
for /F %%i in ('dir /ON /B "%WindowsSdkDir%\include\10.*"') DO (
  SET WindowsSDKVer=%%~i
)
if errorlevel 1 (
    echo "Didn't find any windows 10 SDK. I'm not sure if things will work, but let's try..."
) else (
    echo Windows SDK version found as: "%WindowsSDKVer%"
)

REM Set bitness, toolchain version and SDK.
call "%VSINSTALLDIR%\VC\Auxiliary\Build\vcvars%1.bat" -vcvars_ver=%VS_TOOLCHAIN% %WindowsSDKVer%
REM https://docs.python.org/3.9/distutils/apiref.html#module-distutils.msvccompiler
REM or
REM https://setuptools.pypa.io/en/latest/deprecated/distutils/apiref.html#module-distutils.msvccompiler
REM Force our SDK, rather than the Python was built with.
set DISTUTILS_USE_SDK=1
set MSSdk=1

REM All done, finish here.
goto:eof

REM Various subroutines.

:GetWin10SdkDir
call :GetWin10SdkDirHelper HKLM\SOFTWARE\Wow6432Node > nul 2>&1
if errorlevel 1 call :GetWin10SdkDirHelper HKCU\SOFTWARE\Wow6432Node > nul 2>&1
if errorlevel 1 call :GetWin10SdkDirHelper HKLM\SOFTWARE > nul 2>&1
if errorlevel 1 call :GetWin10SdkDirHelper HKCU\SOFTWARE > nul 2>&1
if errorlevel 1 exit /B 1
exit /B 0

:GetWin10SdkDirHelper
@@REM `Get Windows 10 SDK installed folder`
for /F "tokens=1,2*" %%i in ('reg query "%1\Microsoft\Microsoft SDKs\Windows\v10.0" /v "InstallationFolder"') DO (
    if "%%i"=="InstallationFolder" (
        SET WindowsSdkDir=%%~k
    )
)
exit /B 0

:NoArgErr
echo "Need to specify input bitness, VS year and toolchain number"
echo "e.g 64 2019 14.16"
exit 1
