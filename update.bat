@echo off
cd /d "%~dp0."
:
setlocal enabledelayedexpansion
: ------------------------------------------------------------
:
set _%~n0_OUTDIR=_posts
set _%~n0_NKF=%SystemDrive%\bin\util\nkf\nkf.exe
:
set _%~n0_SRC=%~f1
if not "!_%~n0_SRC!" == "" goto init
call %~nx0 index.textile
goto end
:
: ------------------------------------------------------------
:init
:
set _%~n0_H-=0
for /F "usebackq tokens=1,* delims=^:^ " %%I in (`!_%~n0_NKF! --windows^<%1`) do if "!_%~n0_H-!%%I"=="0---" ( set _%~n0_H-=1 ) else if "%%I"=="---" ( goto break#1 ) else ( set _%~n0_H#%%I=%%J)
:break#1
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
if not defined _%~n0_H#mdescription set /p _%~n0_H#mdescription=topic: 
rem set _%~n0_H#title=!_%~n0_H#mtitle!
rem set _%~n0_H#mtitle=
set _%~n0_H#description=!_%~n0_H#mdescription!
rem set _%~n0_H#mdescription=
:
set _%~n0_H#link=%~pn1.html
set _%~n0_H#link=!_%~n0_H#link:%~p0=!
set _%~n0_H#link=!_%~n0_H#link:^\=^/!
rem set _%~n0_H#link=!_%~n0_H#link!^#!_%~n0_DATE!
:
set _%~n0_H#group=
set _%~n0_H#layout=
:
@echo --->"!_%~n0_DEST!"
@echo.^group^:^ history>>"!_%~n0_DEST!"
for /F "usebackq tokens=1,2* delims==#" %%I in (`set _%~n0_H#`) do @echo.%%J^:^ !_%~n0_H#%%J!>>"!_%~n0_DEST!"
:|!_%~n0_NKF! --oc=UTF-8
@echo layout^:^ redirect>>"!_%~n0_DEST!"
@echo redirect^:>>"!_%~n0_DEST!"
@echo.^ ^ url^:^ !_%~n0_H#link!>>"!_%~n0_DEST!"
@echo.^ ^ delay^:^ ^0>>"!_%~n0_DEST!"
@echo --->>"!_%~n0_DEST!"
: @echo.>>"!_%~n0_DEST!"
:
call !_%~n0_NKF! --oc=UTF-8 --overwrite "!_%~n0_DEST!"
echo out: !_%~n0_DEST!
call !_%~n0_NKF! --windows<"!_%~n0_DEST!"
:
set _%~n0_DATE=!_%~n0_DATE:^-=^.!
@echo ^#>%~n0.x
@echo git tag ^-d ^'!_%~n0_DATE!^'>>%~n0.x
@echo git tag ^-a ^'!_%~n0_DATE!^' -m ^'[!_%~n0_H#category!]!_%~n0_H#title! - !_%~n0_H#mdescription!^'>>%~n0.x
@echo git tag ^-l ^-n>>%~n0.x
@echo echo.>>%~n0.x
@echo ^#>>%~n0.x
call !_%~n0_NKF! --oc=UTF-8 --overwrite %~n0.x
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
