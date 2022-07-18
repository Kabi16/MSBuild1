@echo off
@SET ISDEBUG=false
@FOR %%A IN (%*) DO @IF "%%A"=="debug" @SET ISDEBUG=true
@SET CHAINEDCALL=false
@FOR %%A IN (%*) DO @IF "%%A"=="chain" @SET CHAINEDCALL=true
@SET SERVER=%1

2>NUL CALL :CASE_%SERVER%
IF ERRORLEVEL 1 CALL :DEFAULT_CASE 

ECHO Done.
EXIT /B

:CASE_Ajubeo
  GOTO END_CASE
:CASE_Nexus
  GOTO END_CASE
:CASE_Folder
  GOTO END_CASE
:DEFAULT_CASE
  ECHO Unknown sever "%SERVER%"
  GOTO :EOF 
:END_CASE
  VER > NUL 

@SET MSBUILDDIR=C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin


@Echo --------------------------------------------------------------------
@ECHO Packing Nuget ...
@Echo --------------------------------------------------------------------
@IF %ISDEBUG%==true (
@"%MSBUILDDIR%\msbuild.exe" MerrillCloud.%SERVER%.targets /p:Configuration=debug  /target:NugetPack /clp:ErrorsOnly 
)
@IF %ISDEBUG%==false (
@"%MSBUILDDIR%\msbuild.exe" MerrillCloud.%SERVER%.targets  /target:NugetPack /clp:ErrorsOnly 
)
@Echo Packing Nuget Completed 
@IF NOT "%CHAINEDCALL%"=="true" PAUSE
@Echo --------------------------------------------------------------------
@ECHO Pushing Nuget ...
@Echo --------------------------------------------------------------------
@IF %ISDEBUG%==true (
@"%MSBUILDDIR%\msbuild.exe" MerrillCloud.%SERVER%.targets /p:Configuration=debug  /target:NugetPush /clp:ErrorsOnly 
)
@IF %ISDEBUG%==false (
@"%MSBUILDDIR%\msbuild.exe" MerrillCloud.%SERVER%.targets  /target:NugetPush
)
@Echo Pushing Nuget Completed 
@IF NOT "%CHAINEDCALL%"=="true" PAUSE
@Echo --------------------------------------------------------------------
@ECHO Clearing Package Files
@Echo --------------------------------------------------------------------
@DEL *.nupkg /q /f 
@Echo Pushing Nuget Completed 