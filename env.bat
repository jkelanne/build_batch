@echo off
:: This BATCH file can be used with cmd.exe:
:: Create a new shortcut of cmd.exe with "/k <location_of>env.bat"
echo [NOTE] Running env.bat.. Setting up some really really important stuff!
set BENV=x86_amd64
echo [NOTE] Build environment is set to %BENV%
:: Comment USE_VIRTUAL_DRIVE if you don't want to use it
set USE_VIRTUAL_DRIVE=1

if defined USE_VIRTUAL_DRIVE (
    if exist "w:" (
        echo [NOTE] w:\ already initialized! 
        cd /D w:
    ) else (
        subst w: c:\work
        cd /D w:
    )
) else (
    echo [NOTE] Virtual Drive disabled
)

:: set SDL2 to PATH
set PATH=%PATH%;C:\work\SDL2\lib\x64\;
:: SSH PATH
set PATH=%PATH%;C:\Temp\OpenSSH-Win64;

:: CVS Path
set PATH=%PATH%;C:\Temp\;

:: Set RSH Thingie
set CVS_RSH=ssh

:: Initialize the Visual Studio environment (to get 'cl')
set PATH=%PATH%;C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\
call vcvarsall %BENV%

:: Initialize GIT environment. Or don't.. You could also
set PATH=%PATH%;C:\Program Files\Git\bin;C:\Program Files\Git\cmd

:: Mark the development environment as set. Should be the last thing you do
set DEV_ENV_SET=1