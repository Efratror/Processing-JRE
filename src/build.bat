@ECHO OFF
setlocal ENABLEDELAYEDEXPANSION
rmdir /s /q ..\jre\windows
rmdir /s /q modules
mkdir modules
mkdir classes

REM Loop over all files in lib folder
for /f "delims=" %%f in ('dir /b /a-d-h-s lib') do (
    echo Creating module info for %%f
    jdeps --generate-module-info works\ --ignore-missing-deps lib\%%f
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