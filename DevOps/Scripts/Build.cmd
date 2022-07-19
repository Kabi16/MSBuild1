@ECHO off
@SETLOCAL
@SET CHAINEDCALL=true
@SET SONAR=true
@SET UTC=true
@SET COVERAGE=false
@SET MODE=Release
@FOR %%A IN (%*) DO @IF "%%A"=="nochain" @SET CHAINEDCALL=false
@FOR %%A IN (%*) DO @IF "%%A"=="nosonar" @SET SONAR=false
@FOR %%A IN (%*) DO @IF "%%A"=="noutc" @SET UTC=false
@FOR %%A IN (%*) DO @IF "%%A"=="nocoverage" @SET COVERAGE=false
@FOR %%A IN (%*) DO @IF "%%A"=="Debug" @SET MODE=Debug

REM Provide solution path and sonar key for the service
@SET SOLU="C:\Users\C605978\source\repos\MSBuild\MSBuild.sln"
@SET SOLUPATH="C:\Users\C605978\source\repos\MSBuild"
@SET SCRIPTPATH="C:\Users\C605978\source\repos\MSBuild\DevOps\Scripts"
@SET SONARKEY="SonarAndJenkins"
@SET SONARNAME="SonarQube1"

@SET MSBUILDDIR=C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin
@SET SONARPATH=C:\Users\C605978\sonarqube-9.4.0.54424\sonar-scanner-msbuild-5.7.2.50892-net5.0
@SET COVERAGEPATH=C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Team Tools\Dynamic Code Coverage Tools

@ECHO *** Build Script Execution Starts ***

@ECHO *** Restore Nuget Package ***
REM "%SOLUPATH%\.nuget\NuGet.exe" restore %SOLU%
CD %SOLUPATH% 
dotnet restore --configfile ".nuget\nuget.config"
@ECHO *** Restoration of Nuget package completed ***
CD %SCRIPTPATH%

@IF "%SONAR%"=="true" (
@ECHO *** Sonarqube static code analysis starts ***
@"%SONARPATH%\SonarScanner.MSBuild.exe" begin /k:%SONARKEY% /n:%SONARNAME% /v:"0.1" /d:sonar.cs.vscoveragexml.reportsPaths="TestResults\coverage.xml" /d:sonar.qualitygate.wait=true
@ECHO.
)

@ECHO *** Rebuild the solution in %MODE% Mode ***

@SET MSBUILDARGS=/t:Rebuild /v:m /m:2 /p:Configuration=%MODE% /clp:ErrorsOnly 

@SET StartTime=%Time%
@"%MSBUILDDIR%\msbuild.exe" %SOLU% %MSBUILDARGS% /fl /flp:ErrorsOnly;WarningsOnly
@SET EndTime=%Time%
@SET BUILD_STATUS=%ERRORLEVEL% 
@IF not %BUILD_STATUS%==0 goto fail 
@ECHO Build Start: %StartTime%
@ECHO Build End:   %EndTime%
@ECHO *** Rebuild in %MODE% mode completed ***


@IF "%COVERAGE%"=="false" (
"%COVERAGEPATH%\CodeCoverage.exe" analyze /output:"TestResults\coverage.xml" "TestResults\output.coverage"
@SET BUILD_STATUS=%ERRORLEVEL% 
@IF not %BUILD_STATUS%==0 goto fail 
@ECHO *** Code Coverage Completed ***
)

@IF "%SONAR%"=="true" (
"%SONARPATH%\sonar-scanner-4.7.0.2747\bin\sonar-scanner.exe" end
@ECHO *** Sonarqube static code analysis Completed ***
)


@IF NOT "%CHAINEDCALL%"=="true" PAUSE
@ENDLOCAL
@GOTO End

:fail 
@EXIT /b 1 

:End

@ECHO *** Build Script Execution completed ***
