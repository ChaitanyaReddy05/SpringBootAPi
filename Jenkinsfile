pipeline {
agent any 
tools{
 maven 'maven5'
}
	  parameters {
    gitParameter branchFilter: 'origin/(.*)', defaultValue: 'master', name: 'BRANCH', type: 'PT_BRANCH'
  }
stages {
	
	 stage ('check env phase') {

steps{
	sh script: "echo ${params.BRANCH}"
}

}

   stage ('Compile phase') {

steps{
    script{

        if (params.BRANCH == 'master'){
        sh 'mvn clean package'      
        }
    }
   
}

}

 stage("build & SonarQube analysis") {
            agent any
            steps {
            script{
                if (params.name.equals("master")){
                
                   withSonarQubeEnv('sonarserver') {
                sh 'mvn sonar:sonar'
              }
            }
            }

            }
           
          }
stage("Quality Gate") {
steps {
    script{
    if (params.name.equals("master")){
    timeout(time: 1, unit: 'HOURS') {
    waitForQualityGate abortPipeline: true
    }
    }
    }
    
}
}
 

   stage ('Build phase') {

steps{
    script{
        if (params.name.equals("master")){
        sh  'mvn clean install'
        }
    }
        
}

}
	stage ('Upload Artifacts phase') {

			steps{
			script{
               if (params.name.equals("master")){
				def mavenPom = readMavenPom file:'pom.xml'
				def nexusreponame = mavenPom.version.endsWith("SNAPSHOT") ? "SpringBootApi" : "SpringBootApi-release"
				nexusArtifactUploader artifacts: 
				[[artifactId: 'springbootapi',
				classifier: '', 
				file: "target/springbootapi-${mavenPom.version}.jar", 
				type: 'jar']], 
				credentialsId: 'NEXUS', 
				groupId: 'org.cg.springboot', 
				nexusUrl: '35.153.66.131:8081', 
				nexusVersion: 'nexus3',
				protocol: 'http', 
				repository: nexusreponame, 
				version: "${mavenPom.version}"
				}
            }
			}

}



}
}
