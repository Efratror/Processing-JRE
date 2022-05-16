@ECHO OFF

echo.
echo ---Building custom JRE for processing---
echo.

cd utils
call compileModules.bat || exit /b 1
cd ../

cd compilerModule
call build.bat || cd ../utils && exit /b 1
echo.
cd ../

cd utils
call createWindowsJRE.bat
TIMEOUT /T 5 1>>nul
call createLinuxJRE.bat
TIMEOUT /T 5 1>>nul
call createMacOSJRE.bat
cd ../
echo ---JRE's created---

TIMEOUT /T 2 1>>nul
rmdir /s /q modules

goto :end

:end