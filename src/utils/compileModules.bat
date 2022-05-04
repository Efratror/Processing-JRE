@ECHO OFF
setlocal ENABLEDELAYEDEXPANSION
cd ../
if exist modules (
  rmdir /s /q modules 
)
if exist classes (
  rmdir /s /q classes 
)
if exist works (
  rmdir /s /q works 
)
mkdir modules

REM Loop over all files in lib folder
for /f "delims=" %%f in ('dir /b /a-d-h-s lib') do (
    echo ---Building %%f module---
    echo Creating module info for %%f
    jdeps --generate-module-info works\ --ignore-missing-deps lib\%%f
    copy /y /v lib\%%f modules\%%f  1>nul || goto :error
    set "_=%%f" & ren "modules\%%f" "!_:-=.!"
    call :sub %%~nf
)



set modName=core
set jarPath=core/core.jar

REM Create module for core.jar
echo ---Building core.jar module---
echo Creating module info
jdeps --module-path modules\ --generate-module-info works\ %jarPath%

copy /y /v core\core.jar modules\ 1>nul || goto :error

echo Creating module jar for %modName%.jar
mkdir classes
cd classes
jar xf ..\core\%modName%.jar || goto :error
cd ..\

cd works\%modName%
javac -p %modName%;../../modules -d %cd%\..\..\classes module-info.java || goto :error
echo Compile complete
cd ..\..\

jar uf modules/%modName%.jar -C classes module-info.class || goto :error
echo Repacking complete
echo.

rmdir /s /q classes
rmdir /s /q works

cd utils
goto :end

:error
exit /B 1

:sub
    REM Create module from jar files in lib folder
    set "file=%1"
    set "modName=%file:-=.%"
    echo Creating module jar for %file%.jar

    mkdir classes
    cd classes
    jar xf ..\lib\%file%.jar 1>nul || goto :error
    cd ..\

    cd works\%modName%
    javac -p %modName% -d %cd%\..\..\classes module-info.java || goto :error
    echo Compile complete
    cd ..\..\

    jar uf modules/%modName%.jar -C classes\ module-info.class || goto :error
    rmdir /s /q classes
    rmdir /s /q works
    echo Repacking complete
    echo.   

:end