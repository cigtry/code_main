@echo off
set PRJ_TCL=NIOS_II.tcl
set QSYS_TCL=nios_ii.tcl
echo %PRJ_TCL%
echo %QSYS_TCL%

set work_path=%~dp0
cd /d %work_path%

cd ../
dir

move  /Y PRJ\IP  TCL\


xcopy  PRJ\%PRJ_TCL%  TCL
rd /s/q  PRJ
md PRJ
xcopy   TCL\%PRJ_TCL%  PRJ
del /s/q TCL\*.tcl
move  /Y  TCL\IP PRJ\

xcopy  QSYS\HARDWARE\*.tcl  TCL
rd /s/q  QSYS\HARDWARE
md QSYS\HARDWARE
xcopy   TCL\*.tcl  QSYS\HARDWARE
del /s/q TCL\*.tcl

@echo off
echo clear_down
pause