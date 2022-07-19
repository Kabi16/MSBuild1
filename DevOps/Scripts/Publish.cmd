@ECHO OFF
@SETLOCAL
@SET CHAINEDCALL=true
@SET MODE=Release
@FOR %%A IN (%*) DO @IF "%%A"=="nochain" @SET CHAINEDCALL=false
@FOR %%A IN (%*) DO @IF "%%A"=="Release" @SET MODE=Release

@SET SOLU="C:\Users\C605978\source\repos\MSBuild\src\MSBuild\MSBuild.csproj"
  
@SET MSBUILDDIR=C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin

@ECHO OpsWebUtil Service Host Publishing to folder in %MODE% mode..
@SET StartTime=%Time%
@"%MSBUILDDIR%\msbuild.exe" %SOLU% /p:Platform=AnyCPU;Configuration=%MODE%;PackageFileName=package.zip /t:Rebuild;Package /clp:ErrorsOnly /fl /flp:ErrorsOnly;WarningsOnly
@SET EndTime=%Time%
@SET BUILD_STATUS=%ERRORLEVEL% 
@IF not %BUILD_STATUS%==0 goto fail 
@ECHO Build Start: %StartTime%
@ECHO Build End:   %EndTime%
@ECHO.

@IF NOT "%CHAINEDCALL%"=="true" PAUSE
@ENDLOCAL
@GOTO End

:fail 
@EXIT /b 1 

:End
