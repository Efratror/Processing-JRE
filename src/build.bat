@ECHO OFF

echo.
echo ---Building custom JRE for processing---
echo.

setlocal ENABLEDELAYEDEXPANSION
rmdir /s /q ..\jre\windows
mkdir modules
mkdir classes

cd utils
for /f "delims=" %%f in ('dir /b /a-d-h-s lib') do (
call getJDK.bat || exit /b 1
cd ../
    copy /y /v lib\%%f modules\%%f 1>nul
    set "_=%%f" & ren "modules\%%f" "!_:-=.!"
    call :sub %%~nf
)

rmdir /s /q classes
rmdir /s /q works

mkdir classes

set modName=core
set jarPath=core/core.jar

REM Create module for core.jar
echo Creating module info
jdeps --module-path modules\ --generate-module-info works\ %jarPath%

copy /y /v core\core.jar modules\ 1>nul

echo Creating module jar for %modName%.jar

cd classes
jar xf ..\core\%modName%.jar
cd ..\

cd works\%modName%
javac -p %modName%;../../modules -d %cd%\..\..\classes module-info.java
echo Compile complete
cd ..\..\

jar uf modules/%modName%.jar -C classes module-info.class
echo Repacking complete

rmdir /s /q classes
rmdir /s /q works

REM Create JRE from all modules
jlink --no-header-files --no-man-pages --compress=2 --strip-debug --module-path modules --add-modules core --output ..\jre\windows
echo.
echo ---JRE created---

rmdir /s /q modules

goto :end

:sub
    REM Create module from jar files in lib folder
    set "file=%1"
    set "modName=%file:-=.%"
    echo Creating module jar for %file%.jar

    cd classes
    jar xf ..\lib\%file%.jar
    cd ..\

    cd works\%modName%
    javac -p %modName% -d %cd%\..\..\classes module-info.java
    echo Compile complete
    cd ..\..\

    jar uf modules/%modName%.jar -C classes\ module-info.class
    echo Repacking complete
    echo.

:end