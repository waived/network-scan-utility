@echo off>NUL

if "%1"=="" (
    echo Usage: %~n0.bat ^<ip-address^>
    exit /b
)

set ip=%1
setlocal enabledelayedexpansion

for /f "tokens=1,2,3,4 delims=." %%a in ("!ip!") do (
    set octet1=%%a
    set octet2=%%b
    set octet3=%%c
)
set "host=%octet1%.%octet2%.%octet3%."


for /L %%A IN (1,1,255) DO (
    set ip=!host!%%A

    set i=1
    echo Probing host [ !ip! ] with an ICMP-Echo packet...
    for /f "tokens=*" %%B in ('ping !ip! -n 1 -w 1500') do (
        set/a i=!i!+1
        if !i! EQU 5 (
            set "result=%%B"
        )
    )
    
    Echo.!result! | findstr /C:"Lost = 0">nul && (
        echo HOST ONLINE : !ip!>>result.txt
    ) || (
        REM offline host
    )
)
endlocal

exit /B
