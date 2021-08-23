pipeline {
agent any 
tools{
 maven 'maven5'
}
	  parameters {
    gitParameter branchFilter: 'origin/(.*)', defaultValue: 'master', name: 'BRANCH', type: 'PT_BRANCH'
    
  }
	
	 parameters {
		     string(defaultValue: "All", description: 'Tests?', name: 'run_tests')
	 }
	
stages {
	
	 stage ('check env phase') {

steps{
	sh  "echo ${params.BRANCH}"
    sh "echo ${params.run_tests}"
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
                if (params.BRANCH == 'develop'){                
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
    if (params.BRANCH == 'develop') {
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
        if (params.BRANCH == 'master'){
        sh  'mvn clean install'
        }
    }
        
}

}
	stage ('Upload Artifacts phase') {

			steps{
			script{
               if (params.BRANCH == 'master'){
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
   stage ('Functional Testing') {

steps{
    script{
        if (params.BRANCH == 'master'){
            if (params.run_tests == 'All'){
            
                sh  '''
                    echo "Functional tests done

                '''
            }
            else{
                '''
                echo running on regression
                '''
            }
        }
    }
        
}

}
   stage ('Regression Testing') {

steps{
    script{
        if (params.BRANCH == 'master'){

            
        sh  '''
            echo "Functional tests done

        '''
        }
    }
        
}

}



}
}
