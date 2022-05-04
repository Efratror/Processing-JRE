@ECHO OFF

echo.
echo ---Building custom JRE for processing---
echo.

REM Create JRE from all modules

cd utils
call compileModules.bat || exit /b 1
call getJDK.bat || exit /b 1
cd ../

echo.
echo ---Build JRE for windows---
if exist ..\jre\windows (
  rmdir /s /q ..\jre\windows
)
TIMEOUT /T 2 1>>nul
jlink --no-header-files --no-man-pages --compress=2 --strip-debug --module-path modules;%cd%\openjdk-17.0.2\windows_x64\jmods --add-modules core --output ..\jre\windows || exit /b 1

echo ---Build JRE for linux---
if exist ..\jre\linux (
  rmdir /s /q ..\jre\linux
)
TIMEOUT /T 2 1>>nul
jlink --no-header-files --no-man-pages --compress=2 --strip-debug --module-path modules;%cd%\openjdk-17.0.2\linux_x64\jmods --add-modules core --output ..\jre\linux || exit /b 1

echo ---Build JRE for macOS---
if exist ..\jre\macos (
  rmdir /s /q ..\jre\macos
)
TIMEOUT /T 2 1>>nul
jlink --no-header-files --no-man-pages --compress=2 --strip-debug --module-path modules;%cd%\openjdk-17.0.2\macos_x64\Contents\Home\jmods --add-modules core --output ..\jre\macos || exit /b 1
echo.
echo ---JRE's created---

rmdir /s /q modules
rmdir /s /q openjdk-17.0.2

goto :end

:end