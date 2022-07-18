@ECHO off
@SETLOCAL
@SET CHAINEDCALL=true
@SET SONAR=true
@SET UTC=true
@SET COVERAGE=true
@SET MODE=Release
@FOR %%A IN (%*) DO @IF "%%A"=="nochain" @SET CHAINEDCALL=false
@FOR %%A IN (%*) DO @IF "%%A"=="nosonar" @SET SONAR=false
@FOR %%A IN (%*) DO @IF "%%A"=="noutc" @SET UTC=false
@FOR %%A IN (%*) DO @IF "%%A"=="nocoverage" @SET COVERAGE=false
@FOR %%A IN (%*) DO @IF "%%A"=="Debug" @SET MODE=Debug

REM Provide solution path and sonar key for the service
@SET SOLU="..\..\src\MBCommonLibraryCore\MBCommonLibraryCore.sln"
@SET SOLUPATH="..\..\src\MBCommonLibraryCore"
@SET SCRIPTPATH="..\..\DevOps\Scripts"
@SET SONARKEY="MB-Common-Library-Core"
@SET SONARNAME="MB-Common-Library-Core"


@SET MSBUILDDIR=C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin
@SET SONARPATH=C:\sonar-scanner-msbuild-4.3.1.1372-net46
@SET COVERAGEPATH=C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Team Tools\Dynamic Code Coverage Tools

@ECHO *** Build Script Execution Starts ***

@ECHO *** Restore Nuget Package ***
REM "%SOLUPATH%\.nuget\NuGet.exe" restore %SOLU%
CD %SOLUPATH% 
dotnet restore
@ECHO *** Restoration of Nuget package completed ***
CD %SCRIPTPATH%
@IF "%SONAR%"=="true" (
@ECHO *** Sonarqube static code analysis starts ***
@"%SONARPATH%\SonarScanner.MSBuild.exe" begin /k:%SONARKEY% /n:%SONARNAME% /v:"0.1" /d:sonar.cs.vscoveragexml.reportsPaths="TestResults\coverage.xml"
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

@IF "%UTC%"=="true" (
@ECHO *** Unit Test Execution Starts ***
@RD TestResults /s /q > nul 2>&1
@"%MSBUILDDIR%\msbuild.exe" JMSService.UnitTest.targets /p:SolutionPath=%SOLUPATH% /p:Configuration=%MODE%  /target:ExecuteTestCase > .\UnitTestOutput.txt
ping 127.0.0.1 -n 3 > nul
@ECHO *** Display Unit Test Results ***
type UnitTestOutput.txt
findstr /c:"Build succeeded" UnitTestOutput.txt
@SET BUILD_STATUS=%ERRORLEVEL% 
ECHO *** Unit Test Case Status : %ERRORLEVEL% *** 
@IF NOT %BUILD_STATUS%==0 goto fail
@ECHO *** Unit Test Execution Completed ***
)

@IF "%COVERAGE%"=="true" (
"%COVERAGEPATH%\CodeCoverage.exe" analyze /output:"TestResults\coverage.xml" "TestResults\output.coverage"
@SET BUILD_STATUS=%ERRORLEVEL% 
@IF not %BUILD_STATUS%==0 goto fail 
@ECHO *** Code Coverage Completed ***
)

@IF "%SONAR%"=="true" (
"%SONARPATH%\SonarScanner.MSBuild.exe" end
@ECHO *** Sonarqube static code analysis Completed ***
)


@IF NOT "%CHAINEDCALL%"=="true" PAUSE
@ENDLOCAL
@GOTO End

:fail 
@EXIT /b 1 

:End

@ECHO *** Build Script Execution completed ***
