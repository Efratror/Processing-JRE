@echo off

if exist compilerModule\bin (
    call rmdir /s /q modules
)

echo ---Build compiler module for LS4P---
echo compile module-info
javac -d bin src/module-info.java || exit /b 1
echo compile module
javac -d bin --module-path bin src\com\compiler.java || exit /b 1
echo ---module created---