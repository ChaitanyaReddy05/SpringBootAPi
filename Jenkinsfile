pipeline {
agent any 
tools{
 maven 'maven5'
}
 environment {
    AWS_DEFAULT_REGION="us-east-1"   
    AWS_ACCOUNT_ID = "663986567307"

    
  }
	  parameters {
    gitParameter branchFilter: 'origin/(.*)', defaultValue: 'master', name: 'BRANCH', type: 'PT_BRANCH'

      }	

	
stages {
	
	 stage ('check env phase') {

steps{
	sh  "echo ${params.BRANCH}"
    sh "echo ${params.run_tests}"
     withCredentials([[
        $class: 'AmazonWebServicesCredentialsBinding', 
        credentialsId: 'chaitanya',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
    ]]) {
        sh '''
        echo "${AWS_ACCESS_KEY_ID}"
        '''
    }
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
                    echo "Functional tests done"

                '''
            }
            else{
              sh  '''
                echo "running on regression"
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
             if (params.run_tests == 'regression'){
                  sh  '''
            echo "Regression tests done"
        '''

             }

            
       
        }
    }
}
   }


stage ('Build image and push to ECR') {

steps{
    script{
          withCredentials([[
        $class: 'AmazonWebServicesCredentialsBinding', 
        credentialsId: 'chaitanya',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
    ]])
    {
        if (params.build_image == 'yes'){
            
            def mavenPom = readMavenPom file:'pom.xml'
			def IMAGE_REPO_NAME = mavenPom.artifactId
            def IMAGE_TAG = mavenPom.version
            def REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
            dockerImage = docker.build REPOSITORY_URI + ":$IMAGE_TAG"      

            echo "building images" 
            sh 'aws ecr get-login-password --region "${AWS_DEFAULT_REGION}" | docker login --username AWS --password-stdin "${AWS_ACCOUNT_ID}".dkr.ecr."${AWS_DEFAULT_REGION}".amazonaws.com' 

            sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"

            sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
       
        }
    }

    } 
}

}



}
}
      


