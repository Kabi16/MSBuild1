pipeline{
    agent any
    
    environment {
        dotnet ='C:\\Program Files (x86)\\Microsoft Visual Studio\\2017\\Professional\\MSBuild\\15.0\\Bin\\MSBuild.exe'
        }
        
    triggers {
        pollSCM 'H * * * *'
    }
 }

#check out the code from Git
tages{
 stage('Checkout') {
    steps {
     git url: 'https://github.com/Kabi16/MSBuild1.git', branch: 'master'
     }
  }

#restore command
stage('Restore packages'){
   steps{
      bat "dotnet restore C:\Users\C605978\source\repos\MSBuild\src\MSBuild\MSBuild.csproj"
     }
  }

#clean the solution
stage('Clean'){
    steps{
        bat "dotnet clean C:\Users\C605978\source\repos\MSBuild\src\MSBuild\MSBuild.csproj"
     }
   }

#Build
stage('Build'){
   steps{
      bat "dotnet build C:\Users\C605978\source\repos\MSBuild\src\MSBuild\MSBuild.csproj --configuration Release"
    }
 }
#Testing
stage('Test: Unit Test'){
   steps {
     bat "dotnet test C:\Users\C605978\source\repos\MSBuild\src\MSBuild\MSBuild.csproj"
     }
  }
       
 stage('Test: Integration Test'){
    steps {
       bat "dotnet test C:\Users\C605978\source\repos\MSBuild\src\MSBuild\MSBuild.csproj"
      }
   }
#Publish
stage('Publish'){
     steps{
       bat "dotnet publish C:\Users\C605978\source\repos\MSBuild\src\MSBuild\MSBuild.csproj "
     }
}
