pipeline {
    agent any 
    tools{
         maven 'maven5'
       }
    stages {
      stage ('Build phase') {
      
      steps{
          sh script: 'mvn clean package'      
      }
      
      }
	        stage ('Upload Artifacts phase') {
      
      steps{
			nexusArtifactUploader artifacts: 
			[[artifactId: 'springbootapi',
			classifier: '', 
			file: 'target/springbootapi-1.0-SNAPSHOT.jar', 
			type: 'jar']], 
			credentialsId: 'NEXUS', 
			groupId: 'org.cg.springboot', 
			nexusUrl: '54.83.61.112', 
			nexusVersion: 'nexus3',
			protocol: 'https', 
			repository: 'http://54.83.61.112:8081/repository/SpringBootApi/', 
			version: '1.0-SNAPSHOT'
      }
      
      }
	  
	  
        }
}
