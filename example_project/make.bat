@echo off
if "%1" == "clean" goto clean

:: Get the parent directory name. This will be used for the name of the executable
for %%a in ("%~dp0\.") do set "PARENT=%%~nxa"

if defined DEV_ENV_SET (
    echo [NOTE] development environment already initialized!
) else (
    if exist "..\env.bat" (
        call "..\env.bat"
    ) else (    
        echo No env.bat found!
    )
)

:: The compilition process can be splitted into smaller chunks if needed
set BDIR=build
set ODIR=%BDIR%\obj
set IDIR=%BDIR%\include
set SRCDIR=src

:: If you need different include paths, set them here
set INCLUDES=

if not exist %BDIR% mkdir %BDIR%
if not exist %ODIR% mkdir %ODIR%
if not exist %IDIR% mkdir %IDIR%

:: copy incude files to %IDIR%
echo Copying includes..
for /r %SRCDIR%\ %%g in (*.h) do (
    copy %%g %cd%\%IDIR% >NUL
    echo   Copied %%g  %cd%%IDIR%
)

:: Extra compiler options
set CFLAGS=/W4

:: Extra linker options
::set LDFLAGS=C:\work\SDL2\lib\x64\SDL2.lib C:\work\SDL2_image\lib\x64\SDL2_image.lib C:\work\SDL2_ttf\lib\x64\SDL2_ttf.lib
set LDFLAGS=

echo Compiling..
:: We're compiling and linking in two steps. We could also run the cl with '/link /out:executable.exe' argument
:: For more information about the compiler opitons, see:
:: https://docs.microsoft.com/en-us/cpp/build/reference/compiler-options-listed-by-category?view=vs-2017
for /r src\ %%g in (*.c) do (
    echo   Compiled %%g
    if "%INCLUDES%" == "" (
        cl %CFLAGS% /Fo%cd%\%ODIR%\ /nologo /c %%g /D_WINDOWS
    ) else (
        cl %CFLAGS% /Fo%cd%\%ODIR%\ /c %%g /I %INCLUDES% /D_WINDOWS
    )
)
echo Done compiling...

echo Linking...
echo   Link directory: %cd%\%ODIR%\
link /nologo -debug %cd%\%ODIR%\*.obj %LDFLAGS% -out:%cd%\%BDIR%\%PARENT%.exe
goto done

:: If clean was given as an argument
:clean
echo Cleaning!
rmdir /s build
goto done

:done
echo Build done