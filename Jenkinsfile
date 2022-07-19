def pipeline

env.AppName="MSBuild"

node('master') {
	  switch (env.BRANCH_NAME) {
			case ~/^PR.*/:
			    echo " loading verify-pipeline ${env.BRANCH_NAME}"
				dir("C:\\Users\\C605978\\source\\repos\\MSBuild\\${env.AppName}\\${env.BRANCH_NAME}\\${env.BUILD_ID}") {	
				stage("Checkout Code")
				{
					checkout scm
				}
				validateCode()	
				}
                break            
            default :
                echo "No pipelines configured for branch ${env.BRANCH_NAME}, halting"
                break
     }
	 echo "Running ${env.BRANCH_NAME} -- ${env.BUILD_ID} on ${env.JENKINS_URL}"	 
}
	   

  def validateCode()
   {
	        bat 'cd devOps\\\\scripts'
	        stage("Build Code")
	    {
		     bat '''cd devOps\\scripts
		     call Build.cmd nosonar noutc nocoverage'''
	    }
	        stage("Unit test")
	    {
		     bat '''cd devOps\\scripts
		     call Build.cmd nosonar nocoverage'''
	    }
	        
   }
   
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
