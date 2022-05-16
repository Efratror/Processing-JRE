@ECHO OFF
cd ../

if not exist modules (
    cd utils
    call compileModules.bat || exit /b 1
    cd ../
)

if not exist compilerModule\bin (
    cd compilerModule
    call build.bat || cd ../utils && exit /b 1
    echo.
    cd ../
)

echo ---Build JRE for windows---
set fileName=windows_x64

if exist openjdk-17.0.2 (
  call rmdir /s /q  openjdk-17.0.2
)
mkdir openjdk-17.0.2
cd openjdk-17.0.2

call curl.exe -o %fileName%.zip https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_windows-x64_bin.zip 1>>nul|| goto :downloadError
call jar xf %cd%\%fileName%.zip || goto :downloadError
echo JDK unpacked
ren "jdk-17.0.2" "%fileName%" || goto :downloadError
del %fileName%.zip
cd ../

if exist ..\bin\windows (
  rmdir /s /q ..\bin\windows
  echo Old JRE removed
)
call jlink --no-header-files --no-man-pages --compress=2 --strip-debug --module-path modules;%cd%\compilerModule\bin;%cd%\openjdk-17.0.2\windows_x64\jmods --add-modules core,compilerModule --output ..\bin\windows || goto :error
echo JRE created

cd ../bin
if exist processing-jre-%buildVersion%-windows.zip (
  call del processing-jre-%buildVersion%-windows.zip 1>>nul
  echo Old archive removed
)

call powershell Compress-Archive -f windows  processing-jre-%buildVersion%-windows.zip || goto :packError
echo Archive packed
cd ../src
call rmdir /s /q ..\bin\windows

goto :end

:downloadError
cd ../utils
goto :error

:packError
cd ../src/utils

:error
exit /B 1

:end
if exist openjdk-17.0.2\ (
  call rmdir /s /q  openjdk-17.0.2
)
cd utils
echo ---JRE for windows created---
echo.