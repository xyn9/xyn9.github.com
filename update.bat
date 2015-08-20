@echo off
: echo %~n0 %*
cd /d "%~dp0."
:
setlocal enabledelayedexpansion
: ------------------------------------------------------------
:
set _%~n0_OUTDIR=_posts
set _%~n0_NKF=%SystemDrive%\bin\util\nkf\nkf.exe
:
:
: ------------------------------------------------------------
:init
:
set _%~n0_SRC=%~f1
if "!_%~n0_SRC!" == "" goto end
:
set _%~n0_H-=0
for /F "usebackq tokens=1,* delims=^:^ " %%I in (`!_%~n0_NKF! --windows^<%~s1`) do if "!_%~n0_H-!%%I"=="0---" ( set _%~n0_H-=1 ) else if "%%I"=="---" ( goto break#1 ) else ( set _%~n0_H#%%I=%%J)
:break#1
:
set _%~n0_H#link=%~pn1.html
set _%~n0_H#link=!_%~n0_H#link:%~p0=!
set _%~n0_H#link=!_%~n0_H#link:^\=^/!
:
set _%~n0_DATE=1
if defined _%~n0_H#date set _%~n0_DATE=!_%~n0_H#date!
if "!_%~n0_DATE!" == "1" set _%~n0_DATE=%~t1
set _%~n0_DATE=!_%~n0_DATE:~0,16!
set _%~n0_DATE=!_%~n0_DATE:^/=-!
if not defined _%~n0_H#date set _%~n0_H#date=!_%~n0_DATE!
set _%~n0_DATE=!_%~n0_DATE:^ =-!
set _%~n0_DATE=!_%~n0_DATE:^:=!
set _%~n0_DEST=!_%~n0_OUTDIR!\!_%~n0_DATE!-%~nx1
:
if not defined _%~n0_H#mdate set _%~n0_H#mdate=!_%~n0_H#date!
if not defined _%~n0_H#mdescription set /p _%~n0_H#mdescription=description: 
:
set _%~n0_H#layout=nil
:
@echo --->"!_%~n0_DEST!"
for /F "usebackq tokens=1,2* delims==#" %%I in (`set _%~n0_H#`) do @echo %%J^: !_%~n0_H#%%J!|!_%~n0_NKF! --oc=UTF-8>>"!_%~n0_DEST!"
@echo --->>"!_%~n0_DEST!"
@echo. >>"!_%~n0_DEST!"
@echo ^{^{ page.mdescription ^}^}>>"!_%~n0_DEST!"
@echo. >>"!_%~n0_DEST!"
:
echo out: !_%~n0_DEST!
call !_%~n0_NKF! --windows<"!_%~n0_DEST!"
:
rem pause
rem set _%~n0
rem pause
rem del "!_%~n0_DEST!"
:
:
: ------------------------------------------------------------
:end
:
rem @echo on
for /F "usebackq delims==" %%I in (`set _%~n0`) do set %%I=
set _%~n0
rem @echo off
:
echo - %~nx0 -done-
