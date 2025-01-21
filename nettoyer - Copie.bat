@echo off
title MFD Tools
color a

:Question (
    cls
    echo **************************************************************************
    echo **************************************************************************
    echo ********************************* WELCOME ********************************
    echo *********************************** TO ***********************************
    echo *************************kevin management*********************************
    echo **************************************************************************
    echo **************************************************************************
    echo. 
    echo.
    echo Quelle action souhaitez vous effectuer ?
    echo     1. Setup Proxy
    echo     2. Setup Domain
    echo     3. Supprimer les fichier temporaire/cache
    echo     4. Optimisation de Windows
    echo     5. Optimisation de rÃ©seaux
    echo     6. Fix reseaux
    echo.

    set /p numSelect= Action: 
    if %numSelect% GTR 6 goto :Question
)

:action (
    echo Action selectionne: %numSelect%
    set /p confSelect= Confirmer l'execution de l'option %numSelect% (y/n): 
    if %confSelect% EQU n goto :Question


    if %numSelect% EQU 1 goto :SetupProxy
    if %numSelect% EQU 2 goto :SetupDomain
    if %numSelect% EQU 3 goto :DeleteTemp
    if %numSelect% EQU 4 goto :SetupOpti
    if %numSelect% EQU 5 goto :ReseauxOpti
    if %numSelect% EQU 6 goto :FixReseaux
)

:SetupProxy (
    reg del "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f
    reg del "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d none /f
    reg del "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride /t REG_SZ /d "none" /f
    goto :Question
)

:SetupDomain (
    set domain = none
    set /p conputerName = Nom de l'ordinateur: 
    set /p adminUser = Username: 
    set /p passwd = Password: 
    netdom join %conputerName% /domain:%domain% /userd:%adminUser% /passwordd:%passwd%
    goto :Question
)

:DeleteTemp (
    if exist "c:\Windows\Prefetch" (
        del c:\Windows\Prefetch /f /s /q
        rd c:\Windows\Prefetch /s /q   
    )
    if exist "c:\Windows\SoftwareDistribution\Download" (
        del c:\Windows\SoftwareDistribution\Download /f /s /q
        rd c:\Windows\SoftwareDistribution\Download /s /q    
    )
    if exist "c:\Users\%username%\AppData\Local\Temp" (
        del c:\Users\%username%\AppData\Local\Temp /f /s /q
        rd c:\Users\%username%\AppData\Local\Temp /s /q    
    )
    if exist "c:\Windows\Temp" (
        del c:\Windows\Temp /f /s /q
        rd c:\Windows\Temp /s /q        
    )
    if exist "c:\Users\%username%\AppData\Local\Microsoft\Windows\Explorer" (
        del c:\Users\%username%\AppData\Local\Microsoft\Windows\Explorer /f /s /q
        rd c:\Users\%username%\AppData\Local\Microsoft\Windows\Explorer /s /q        
    )
	ipconfig /flushdns
    goto :Question
)

:SetupOpti (
    reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f
    reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f

    goto :Question
)

:FixReseaux (
    netsh winsock reset
    netsh int ip reset
    ipconfig /flushdns
    ipconfig /release
    ipconfig /renew
    
    goto :Question
)

:ReseauxOpti (
    netsh interface tcp show global
    netsh int tcp set global rsc=disabled
    netsh int tcp set heuristics disabled
    netsh int tcp set global initialRto=2500
    reg add "HKLMA\SOFTWARE\Policies\Microsoft\Windows\Psched" /v NonBestEffortLimit /t REG_DWORD /d 0 /f
    goto :Question
)

pause