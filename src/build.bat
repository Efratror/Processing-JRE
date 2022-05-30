@ECHO OFF

echo.
echo ---Building custom JRE for processing---
echo.

cd utils
REM call compileModules.bat || exit /b 1
cd ../

call ../gradlew build || exit /b 1
echo.
cd utils
call createWindowsJRE.bat
TIMEOUT /T 5 1>>nul
call createLinuxJRE.bat
TIMEOUT /T 5 1>>nul
call createMacOSJRE.bat
cd ../
echo ---JRE's created---

goto :end

:end