@echo off
title Tauri 2.0 Environment Verifier - linksaverapp
cd /d "D:\STANDALONES\Tauri\linksaverapp"
cls

echo =======================================================
echo          TAURI 2.0 WINDOWS ENVIRONMENT CHECK
echo   Path: D:\STANDALONES\Tauri\linksaverapp
echo =======================================================
echo.

:: 1. Check Node.js and NPM
echo [1/5] Checking JavaScript Ecosystem...
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [X] Node.js is NOT installed or not in System PATH!
    echo     Please download it from https://nodejs.org
    goto failed
)
for /f "tokens=*" %%i in ('node -v') do set NODE_VER=%%i
for /f "tokens=*" %%i in ('npm -v') do set NPM_VER=%%i
echo     - Node.js Version: %NODE_VER% (Expected: v20+ or v22+)
echo     - NPM Version: %NPM_VER%
echo.

:: 2. Check Rust Compiler
echo [2/5] Checking Rust Compiler Engine...
where cargo >nul 2>nul
if %errorlevel% neq 0 (
    echo [X] Rust/Cargo is NOT installed or not in System PATH!
    echo     Please install it via https://rustup.rs
    goto failed
)
for /f "tokens=*" %%i in ('cargo --version') do set CARGO_VER=%%i
echo     - %CARGO_VER%
echo.

:: 3. Check VS C++ Build Tools (Crucial for Tauri builds on Windows)
echo [3/5] Checking MSVC Build Tools Engine...
set "MSVC_FOUND=0"
if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" (
    for /f "usebackq tokens=*" %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
        if exist "%%i" set "MSVC_FOUND=1"
    )
)
if "%MSVC_FOUND%"=="0" (
    echo [X] WARNING: Microsoft C++ Build Tools component was NOT detected!
    echo     You need the "Desktop development with C++" workload installed
    echo     via the Visual Studio Installer to build Tauri executables.
) else (
    echo     - Microsoft C++ Build Tools are correctly installed.
)
echo.

:: 4. Check Windows WebView2 Runtime
echo [4/5] Checking WebView2 App Shell...
reg query "HKLM\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}" /v pv >nul 2>nul
if %errorlevel% neq 0 (
    reg query "HKCU\Software\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}" /v pv >nul 2>nul
    if %errorlevel% neq 0 (
        echo [X] WebView2 Runtime not detected. (Usually default on Windows 10/11)
    ) else (
        echo     - WebView2 Runtime is active and ready.
    )
) else (
    echo     - WebView2 Runtime is active and ready.
)
echo.

:: 5. Internal Project Check
echo [5/5] Checking Local Node Modules...
if not exist "node_modules\" (
    echo [!] "node_modules" folder is missing. 
    echo     Running "npm install" to fix this right now...
    call npm install
) else (
    echo     - Project dependecies are locally present.
)
echo.

echo =======================================================
echo     VERIFICATION COMPLETE! Ready to test workspace.
echo =======================================================
echo  1. Run Tauri in Dev Mode (Test window rendering)
echo  2. Close this tool
echo =======================================================
set /p final_choice="Select next step (1-2): "

if "%final_choice%"=="1" (
    cls
    echo Launching Dev Server...
    call npm run tauri dev
)
goto end

:failed
echo.
echo [X] Environment verification failed. Please fix the missing paths above.
pause

:end
exit
