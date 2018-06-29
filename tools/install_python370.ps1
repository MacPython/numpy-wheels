# Install Python 3.7.0, if current matrix entry requires it.
$req_ver="3.7.0"
$req_nodot="37"

if ($env:PYTHON -eq "C:\Python${req_nodot}-x64") {
    $exe_suffix="-amd64"
} elseif ($env:PYTHON -eq "C:\Python${req_nodot}") {
    $exe_suffix=""
} else {
    exit 0
}

$py_url = "https://www.python.org/ftp/python"
Write-Host "Installing Python ${req_ver}$exe_suffix..." -ForegroundColor Cyan
$exePath = "$env:TEMP\python-${req_ver}${exe_suffix}.exe"
$downloadFile = "$py_url/${req_ver}/python-${req_ver}${exe_suffix}.exe"
Write-Host "Downloading $downloadFile..."
(New-Object Net.WebClient).DownloadFile($downloadFile, $exePath)
Write-Host "Installing..."
cmd /c start /wait $exePath /quiet TargetDir="$env:PYTHON" Shortcuts=0 Include_launcher=0 InstallLauncherAllUsers=0
Write-Host "Python ${req_ver} installed to $env:PYTHON"

echo "$(& $env:PYTHON\Python.exe --version 2> $null)"
