@ECHO OFF

REM // make sure we can write to the file Sonicbuilt.bin
REM // also make a backup to Sonicbuilt.prev.bin
IF NOT EXIST RobiEngineBuilt.bin goto LABLNOCOPY
IF EXIST RobiEngineBuilt.prev.bin del RobiEngineBuilt.prev.bin
IF EXIST RobiEngineBuilt.prev.bin goto LABLNOCOPY
move /Y RobiEngineBuilt.bin RobiEngineBuilt.prev.bin > NUL
IF EXIST RobiEngineBuilt.bin goto LABLERROR3
REM IF EXIST Sonicbuilt.prev.bin copy /Y Sonicbuilt.prev.bin Sonicbuilt.bin
:LABLNOCOPY

REM // delete some intermediate assembler output just in case
IF EXIST Sonic.p del Sonic.p
IF EXIST Sonic.p goto LABLERROR2
IF EXIST Sonic.h del Sonic.h
IF EXIST Sonic.h goto LABLERROR1

REM // clear the output window
cls

REM // run the rings conversion program
cd level/ring_pos
rings.exe
cd ../..


REM // run the assembler
REM // -xx shows the most detailed error output
REM // -c outputs a shared file (s2.h)
REM // -q shuts up AS
REM // -U forces case-sensitivity
REM // -A gives us a small speedup
set AS_MSGPATH=win32/as
set USEANSI=n

set debug_syms= -xx
set print_err=-E
set revision_override=
set s2p2bin_args=

:parseloop
IF "%1"=="-ds" (
	set debug_syms=-g MAP
	echo Will generate debug symbols
)
IF "%1"=="-pe" (
	REM // allow the user to choose to print error messages out by supplying the -pe parameter
	set print_err=
	echo Selected detailed assembler output
)
IF "%1"=="-a" (
	set s2p2bin_args=-a
	echo Will use accurate sound driver compression
)
IF "%1"=="-r0" (
	set revision_override=-D gameRevision=0
	echo Building REV00
)
IF "%1"=="-r1" (
	set revision_override=-D gameRevision=1
	echo Building REV01
)
IF "%1"=="-r2" (
	set revision_override=-D gameRevision=2
	echo Building REV02
)
SHIFT
IF NOT "%1"=="" goto parseloop

echo Assembling...

"win32/as/asw" -xx -c %debug_syms% %print_err% -A -U -L %revision_override% Sonic.asm

REM // if there were errors, there won't be any Sonic.p output
IF NOT EXIST Sonic.p goto LABLERROR5

REM // combine the assembler output into a rom
"win32/s2p2bin" %s2p2bin_args% Sonic.p RobiEngineBuilt.bin Sonic.h

REM // fix some pointers and things that are impossible to fix from the assembler without un-splitting their data
IF EXIST RobiEngineBuilt.bin "win32/fixpointer" Sonic.h RobiEngineBuilt.bin   off_3A294 MapRUnc_Sonic $2D 0 4   word_728C_user Obj5F_MapUnc_7240 2 2 1
REM // Import Labels for the error handler (this doesn't work on Raspbian at the moment)

IF EXIST RobiEngineBuilt.bin "misc/ErrorHandler/ConvertSymbol.exe" Sonic.lst RobiEngineBuilt.bin -input as_lst -a

REM REM // fix the rom header (checksum)
IF EXIST RobiEngineBuilt.bin "win32/fixheader" RobiEngineBuilt.bin

REM // if there were errors/warnings, a log file is produced
IF EXIST Sonic.log goto LABLERROR4


REM // done -- pause if we seem to have failed, then exit
IF EXIST RobiEngineBuilt.bin exit /b

pause


exit /b

:LABLERROR1
echo Failed to build because write access to Sonic.h was denied.
pause


exit /b

:LABLERROR2
echo Failed to build because write access to Sonic.p was denied.
pause


exit /b

:LABLERROR3
echo Failed to build because write access to Sonicbuilt.bin was denied.
pause

exit /b

:LABLERROR4
REM // display a noticeable message
echo.
echo **********************************************************************
echo *                                                                    *
echo *      There were build warnings. See Sonic.log for more details.    *
echo *                                                                    *
echo **********************************************************************
echo.
pause

exit /b

:LABLERROR5
REM // display a noticeable message
echo.
echo **********************************************************************
echo *                                                                    *
echo *       There were build errors. See Sonic.log for more details.     *
echo *                                                                    *
echo **********************************************************************
echo.
pause


