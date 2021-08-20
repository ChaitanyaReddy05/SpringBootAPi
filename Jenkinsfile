pipeline {
agent any 
tools{
 maven 'maven5'
}
stages {

   stage ('Compile phase') {

steps{
  sh script: 'mvn clean package'      
}

}

stage("build & SonarQube analysis") {
	agent any
	steps {
	  withSonarQubeEnv('sonarserver') {
			sh 'mvn  sonar:sonar'
	  }
	  timeout(time: 1, unit: 'HOURS') {
	  script{
	  
		 def qg = waitForQualityGate()
		if (qg.status != 'OK') {
		  error "Pipeline aborted due to quality gate failure: ${qg.status}"
	  }
	  }

  }
	}
  }
 

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


