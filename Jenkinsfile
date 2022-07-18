pipeline {

   agent any
  
   stages {
   
     stage('SonarQube analysis') {
      steps {
         script {
        def scannerHome = tool 'SonarQube';
        withSonarQubeEnv('SonarQube') {
           bat "${scannerHome}/bin/sonar-scanner \
              -D sonar.login=admin \
              -D sonar.password=admin123 \
              -D sonar.projectKey=SonarQube1 \
              -D sonar.exclusions=vendor/**,resources/**,**/*.java \
              -D sonar.host.url=http://5CG8301V3J:9000/"
           }
        }
     }
  }
     stage("Build") {
        when {
           expression {
              BRANCH_NAME == 'master'
           }
        }
       steps {
            echo "Building the application"
       }
     }
   
     stage("Test") {
         when {
           expression {
              BRANCH_NAME == 'master'
           }
        }
       steps {
            echo "Testing the application"
       }
     }
     
     stage("Deploy") {
        steps {
            echo "Deploying the application"
              }
          }
          stage("Quality Gates"){
             steps {
                timeout(time: 1,unit: 'HOURS') {
                   script {
                       def qg = waitForQualityGate()
                       if (qg.status != "OK") {
                       error "Pipeline aborted due to quality gate failure: ${qg.status}"
                       }
                    }
            }
         }    
        }
   }
}