@echo off
title Tauri Production Compiler + Auto Icons - linksaverapp
cd /d "D:\STANDALONES\Tauri\linksaverapp"
cls

echo =======================================================
echo         TAURI 2.0 AUTOMATED COMPILATION PIPELINE
echo   Path: D:\STANDALONES\Tauri\linksaverapp
echo =======================================================
echo.

:: 1. Automated Dependency Sync & Tauri 2.0 Force Install
echo [1/4] Verifying and enforcing Tauri 2.0 dependencies...
if not exist "node_modules\" (
    echo     [!] "node_modules" folder is missing. 
    echo     [+] Running complete "npm install"...
    call npm install
)

echo     [+] Enforcing latest stable Tauri 2.0 components...
:: Force installs the absolute latest v2 releases to clear any old v1 conflicts
call npm install @tauri-apps/api@latest --no-audit --no-fund
call npm install -D @tauri-apps/cli@latest --no-audit --no-fund
echo.

:: 2. Automated Asset Optimization / Generation
echo [2/4] Verifying and generating asset iconography...
if not exist "app-icon.png" (
    echo [!] WARNING: "app-icon.png" was not found in the root directory.
    echo     Skipping auto-generation. Default Tauri placeholders will be used.
) else (
    echo     [+] Master asset "app-icon.png" detected!
    echo     [+] Parsing and compiling multi-format asset grid via Tauri CLI...
    call npx tauri icon app-icon.png
    echo     [+] Icon bundle assets generated successfully.
)
echo.

:: 3. Compilation Block
echo [3/4] Executing native Rust compilation suite...
echo       Targets will compile inside: src-tauri\target\release\bundle\
echo       Please wait, production optimization loops take a moment...
echo.

call npm run tauri build

:: 4. Post-Compile Validation
echo.
echo [4/4] Analyzing build output pipeline...
if %errorlevel% neq 0 (
    echo.
    echo [X] BUILD FAILED! Check the terminal console output logs above.
    pause
    exit /b %errorlevel%
) else (
    echo.
    echo [!] SUCCESS! Production binaries compiled perfectly.
    echo     Opening your installer folder right now...
    explorer "D:\STANDALONES\Tauri\linksaverapp\src-tauri\target\release\bundle"
)

pause
