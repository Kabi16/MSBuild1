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
	         stage("sonar Run")
	    {
		      bat '''cd devOps\\scripts
		      call Build.cmd noutc'''
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
