pipeline {
    agent any 
    tools{
         maven 'maven5'
       }
    stages {
      stage ('Build phase') {
      
      steps{
          sh script: 'mvn clean install'      
      }
      
      }
	        stage ('Upload Artifacts phase') {
      
      steps{
	  script{
			def mavenPom = readMavenPom file:'pom.xml'
		  	def nexusreponame = mavenPom.version.endsWith("SNAPSHOT") ? "SpringBootApi" : "SpringBootApi-release"
			nexusArtifactUploader artifacts: 
			[[artifactId: 'springbootapi',
			classifier: '', 
			file: "target/springbootapi-${mavenPom.version}.jar", 
			type: 'jar']], 
			credentialsId: 'NEXUS', 
			groupId: 'org.cg.springboot', 
			nexusUrl: '54.83.61.112:8081', 
			nexusVersion: 'nexus3',
			protocol: 'http', 
			repository: nexusreponame, 
			version: "${mavenPom.version}"
			}
      }
      
      }
	  
	  
        }
}
