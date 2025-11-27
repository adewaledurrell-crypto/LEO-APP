@echo off
REM WaowoShop - Build Script for Windows

setlocal enabledelayedexpansion

REM Couleurs (simples pour Windows)
set "GREEN=[92m"
set "YELLOW=[93m"
set "RED=[91m"
set "BLUE=[94m"
set "NC=[0m"

set "BUILD_TYPE=%1"
if "%BUILD_TYPE%"=="" set "BUILD_TYPE=release"

echo.
echo %BLUE%========================================%NC%
echo %BLUE%WaowoShop - Build Script%NC%
echo %BLUE%========================================%NC%
echo.

REM Vérifier Flutter
echo %BLUE%Checking Flutter installation...%NC%
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo %RED%Error: Flutter is not installed!%NC%
    exit /b 1
)
flutter --version
echo.

REM Nettoyer
echo %BLUE%Cleaning previous builds...%NC%
call flutter clean
if %errorlevel% neq 0 (
    echo %RED%Error during clean!%NC%
    exit /b 1
)
echo %GREEN%Build cleaned%NC%
echo.

REM Dépendances
echo %BLUE%Getting dependencies...%NC%
call flutter pub get
if %errorlevel% neq 0 (
    echo %RED%Error getting dependencies!%NC%
    exit /b 1
)
echo %GREEN%Dependencies installed%NC%
echo.

REM Analyser
echo %BLUE%Analyzing code...%NC%
call flutter analyze
echo %GREEN%Analysis complete%NC%
echo.

REM Build
if "%BUILD_TYPE%"=="release" (
    echo %BLUE%Building APK (release mode)...%NC%
    call flutter build apk --release
    if %errorlevel% neq 0 (
        echo %RED%Error building APK!%NC%
        exit /b 1
    )
    set "APK_PATH=build\app\outputs\flutter-apk\app-release.apk"
) else if "%BUILD_TYPE%"=="debug" (
    echo %BLUE%Building APK (debug mode)...%NC%
    call flutter build apk --debug
    if %errorlevel% neq 0 (
        echo %RED%Error building APK!%NC%
        exit /b 1
    )
    set "APK_PATH=build\app\outputs\flutter-apk\app-debug.apk"
) else if "%BUILD_TYPE%"=="bundle" (
    echo %BLUE%Building App Bundle...%NC%
    call flutter build appbundle --release
    if %errorlevel% neq 0 (
        echo %RED%Error building App Bundle!%NC%
        exit /b 1
    )
    set "APK_PATH=build\app\outputs\bundle\release\app-release.aab"
) else (
    echo %RED%Unknown build type: %BUILD_TYPE%%NC%
    exit /b 1
)

echo.
echo %GREEN%Build completed successfully!%NC%
if exist "%APK_PATH%" (
    for %%F in ("%APK_PATH%") do (
        set "SIZE=%%~zF"
        set /A SIZE_MB=SIZE/1048576
        echo %GREEN%APK Size: !SIZE_MB! MB%NC%
    )
) else (
    echo %YELLOW%Warning: APK file not found at expected location%NC%
)

echo.
echo %BLUE%========================================%NC%
echo %GREEN%Build finished!%NC%
echo %BLUE%========================================%NC%

endlocal
pause
