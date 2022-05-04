
@ECHO OFF
cd ../
if exist openjdk-17.0.2 (
  rmdir /s /q  openjdk-17.0.2 
)
mkdir openjdk-17.0.2

cd openjdk-17.0.2

set fileName=windows_x64
echo ---Get JDK for windows---
curl.exe -o %fileName%.zip https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_windows-x64_bin.zip || goto :error
jar xf %cd%\%fileName%.zip || goto :error
pushd %cd%\jdk-17.0.2 || goto :error
for /D %%D in ("*") do (
    if /I not "%%~nxD"=="jmods" rd /S /Q "%%~D"
)
for %%F in ("*") do (
    del "%%~F"
)
popd
ren "jdk-17.0.2" "%fileName%" || goto :error
del %fileName%.zip


set fileName=linux_x64
echo.
echo ---Get JDK for linux---
curl.exe -o %fileName%.tar.gz https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz || goto :error
tar -xzf %cd%\%fileName%.tar.gz jdk-17.0.2/jmods/ || goto :error
ren "jdk-17.0.2" "%fileName%" || goto :error
del %fileName%.tar.gz
echo.

set fileName=macos_x64
echo ---Get JDK for macOS---
curl.exe -o %fileName%.tar.gz https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_macos-aarch64_bin.tar.gz || goto :error
tar -xzf %cd%\%fileName%.tar.gz jdk-17.0.2.jdk/Contents/Home/jmods || goto :error
ren "jdk-17.0.2.jdk" "%fileName%" || goto :error
del %fileName%.tar.gz

goto :end

:error
exit /B 1

:end
cd ../utils