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

echo ---Build JRE for linux---
set fileName=linux_x64

if exist openjdk-17.0.2 (
  call rmdir /s /q  openjdk-17.0.2
)
mkdir openjdk-17.0.2
cd openjdk-17.0.2

call curl -o %fileName%.tar.gz https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz || goto :downloadError
call tar -xzf %cd%\%fileName%.tar.gz jdk-17.0.2/jmods/ || goto :downloadError
echo JDK unpacked
ren "jdk-17.0.2" "%fileName%" || goto :downloadError
del %fileName%.tar.gz
cd ../

if exist ..\jre\linux (
  rmdir /s /q ..\jre\linux
  echo Old JRE removed
)
call jlink --no-header-files --no-man-pages --compress=2 --strip-debug --module-path modules;%cd%\compilerModule\bin;%cd%\openjdk-17.0.2\linux_x64\jmods --add-modules core,compilerModule --output ..\jre\linux || goto :error
echo JRE created

cd ../jre
if exist processing-jre-%buildVersion%-linux.tar.gz (
  call del processing-jre-%buildVersion%-linux.tar.gz 1>>nul
  echo Old archive removed
)

call tar -czf processing-jre-%buildVersion%-linux.tar.gz linux  || goto :packError
echo Archive packed
cd ../src
call rmdir /s /q ..\jre\linux

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
echo ---JRE for linux created---
echo.