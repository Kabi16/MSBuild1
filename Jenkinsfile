
pipeline {
    
    agent any
    
    stages {
    
    environment {
        dotnet ='C:\\Program Files (x86)\\Microsoft Visual Studio\\2017\\Professional\\MSBuild\\15.0\\Bin\\MSBuild.exe'
        }
        
    triggers {
        pollSCM 'H * * * *'
    }
  }
}
stages {
 stage('Checkout') {
    steps {
     git url: 'https://github.com/Kabi16/MSBuild1.git', branch: 'master'
     }
  }

stage('Restore packages'){
   steps{
      bat "dotnet restore C:\\Users\\C605978\\source\\repos\\MSBuild\\src\\MSBuild\\MSBuild.csproj"
     }
  }

stage('Clean'){
    steps{
        bat "dotnet clean C:\\Users\\C605978\\source\\repos\\MSBuild\\src\\MSBuild\\MSBuild.csproj"
     }
   }

stage('Build'){
   steps{
      bat "dotnet build C:\\Users\\C605978\\source\\repos\\MSBuild\\src\\MSBuild\\MSBuild.csproj --configuration Release"
    }
 }

stage('Test: Unit Test'){
   steps {
     bat "dotnet test C:\\Users\\C605978\\source\\repos\\MSBuild\\src\\MSBuild\\MSBuild.csproj"
     }
  }
       
 stage('Test: Integration Test'){
    steps {
       bat "dotnet test C:\\Users\\C605978\\source\\repos\\MSBuild\\src\\MSBuild\\MSBuild.csproj"
      }
   }
    
stage('Publish'){
     steps{
       bat "dotnet publish C:\\Users\\C605978\\source\\repos\\MSBuild\\src\\MSBuild\\MSBuild.csproj "
     }
  }
 }
