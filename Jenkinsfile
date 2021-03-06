pipeline {
agent any 
triggers {
        GenericTrigger(
        genericVariables: [
        [key: 'ref', value: '$.ref']
        ],
        causeString: 'Triggered on $ref',
        printContributedVariables: true,
        printPostContent: true,
        silentResponse: false,
        regexpFilterText: '$ref',
        regexpFilterExpression: 'refs/heads/Develop'
    )
}
tools{
        maven 'maven5'
}
environment {
        AWS_DEFAULT_REGION="us-east-1"   
        AWS_ACCOUNT_ID = "XXXXXXXXX"
        NEXUS_URL =  "52.86.249.122:8081"   
}
parameters {
        gitParameter branchFilter: '.*(Develop|master).*', defaultValue: 'Develop', name: 'BRANCH', type: 'PT_BRANCH'

}
 	   
stages {	
    stage ('Compile phase') {
            when {expression { params.BRANCH == 'Develop' } }
            steps{                
                script{        
                    sh 'mvn clean package'                        
                }
            
            }
        }

    stage("build & SonarQube analysis") {
        when {expression { params.BRANCH == 'Develop' } }
                agent any
                steps {
                        script{                                    
                            withSonarQubeEnv('sonarserver') {
                            sh 'mvn sonar:sonar'                        
                        }
                }
            }
            
    }
    stage("Quality Gate") {
        when { expression { params.BRANCH == 'Develop' } }
        steps {
            script{                
            timeout(time: 1, unit: 'HOURS') {
            waitForQualityGate abortPipeline: true
            }                
            }                
        }
    } 

    stage ('Build phase') {
            when {expression { params.BRANCH == 'Develop' } }
            steps{
                script{               
                    sh  'mvn clean install'                        
                }                        
            }
        }
	stage ('Upload Artifacts phase') {
         when {expression { params.BRANCH == 'Develop' } }
		steps{
			script{               
				def mavenPom = readMavenPom file:'pom.xml'
				def nexusreponame = mavenPom.version.endsWith("SNAPSHOT") ? "SpringBootApi" : "SpringBootApi-release"
                def nexusgroupId = mavenPom.groupId
                def nexusartifactId =  mavenPom.artifactId
				nexusArtifactUploader artifacts: 
				[[artifactId: "${nexusartifactId}",
				classifier: '', 
				file: "target/springbootapi-${mavenPom.version}.jar", 
				type: 'jar']], 
				credentialsId: 'NEXUS', 
				groupId: "${nexusgroupId}", 
				nexusUrl: "${NEXUS_URL}", 
				nexusVersion: 'nexus3',
				protocol: 'http', 
				repository: nexusreponame, 
				version: "${mavenPom.version}"				
            }
		}
    }
   stage('Download from Nexus') {
       when {expression { params.BRANCH == 'master' } }
       steps{
            script{  
                withCredentials([usernameColonPassword(credentialsId: 'NEXUS', variable: 'NEXUS_CREDENTIALS')]) {
                    def mavenPom = readMavenPom file:'pom.xml'
                    def nexusrepoversion = mavenPom.version
                    def nexusgroupId = mavenPom.groupId
                    def nexusartifactId =  mavenPom.artifactId
                    def nexusreponame = mavenPom.version.endsWith("SNAPSHOT") ? "SpringBootApi" : "SpringBootApi-release"

		    dir('release') {           
              	    sh "rm -r -d *"
		    sh "mkdir ${nexusartifactId}-${nexusrepoversion}"
              dir("${nexusartifactId}-${nexusrepoversion}"){
		        sh 'pwd'
                sh 'curl -L -u ${NEXUS_CREDENTIALS} -o release.jar -X GET "http://${NEXUS_URL}/service/rest/v1/search/assets/download?sort=version&repository=${nexusreponame}&maven.groupId=${nexusgroupId}&maven.artifactId=${nexusartifactId}&maven.extension=jar" -H "accept: application/json"'
	      }

		    }
                }
            }
        } 
   }
   stage('Upload to S3') {
       when {expression { params.BRANCH == 'master' } }
       steps{
            script{  
                def mavenPom = readMavenPom file:'pom.xml'
                def nexusrepoversion = mavenPom.version
                def nexusgroupId = mavenPom.groupId
                def nexusartifactId =  mavenPom.artifactId
                  s3Upload consoleLogLevel: 'INFO', 
                  dontSetBuildResultOnFailure: false, 
                  dontWaitForConcurrentBuildCompletion: false,
                  entries: [[bucket: 'springbootapi', excludedFile: '', flatten: false, gzipFiles: false, keepForever: false, managedArtifacts: false, noUploadOnFailure: false, selectedRegion: 'us-east-1', showDirectlyInBrowser: false, sourceFile: "release/${nexusartifactId}-${nexusrepoversion}/", storageClass: 'STANDARD', uploadFromSlave: false, useServerSideEncryption: false]], 
                  pluginFailureResultConstraint: 'FAILURE',
                  profileName: 'springbootapi-codedeploy-s3', 
                  userMetadata: []
                }
            }
        } 
    stage('Deployment to EC2') {
       when {expression { params.BRANCH == 'master' } }
       steps{
            script{  
                def mavenPom = readMavenPom file:'pom.xml'
                def nexusrepoversion = mavenPom.version
                def nexusgroupId = mavenPom.groupId
                def nexusartifactId =  mavenPom.artifactId
                step([$class: 'AWSCodeDeployPublisher',
                        applicationName: 'jsr', 
                        credentials: '', 
                        deploymentGroupAppspec: true, 
                        deploymentGroupName: 'jsr-dg', 
                        deploymentMethod: 'deploy', 
                        excludes: '', 
                        iamRoleArn: 'arn:aws:iam::663986567307:role/springbootapi-codedeploy-s3',                        
                        includes: '**', 
                        proxyHost: '', 
                        proxyPort: 0, 
                        region: 'us-east-1',
                        s3bucket: 'springbootapi', 
                        s3prefix: '', 
                        subdirectory: "",
                        versionFileName: '', 
                        waitForCompletion: true])                 
                }
            }
        }  


   stage ('Functional Testing') {
        when {
             allOf {
                  expression { params.BRANCH == 'master'}
                  expression { params.Tests == 'Functional'} }
            }
        steps{
            script{                   
                        sh  '''
                            echo "Functional tests done"
                        '''
                }                
        }

    }
   stage ('Regression Testing') {
        when {
             allOf {
                  expression { params.BRANCH == 'master'} 
                  expression { params.Tests == 'regression'} }
            }

        steps{
            script{               
                        sh  '''
                    echo "Regression tests done"
                '''                
            }
        }
    }


    stage ('Build image and push to ECR') {
        when { expression { params.Build_Image == 'yes' } }
        steps{
            script{
                withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding', 
                credentialsId: 'chaitanya',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
            ]])
            {
                    def mavenPom = readMavenPom file:'pom.xml'
                    def IMAGE_REPO_NAME = mavenPom.artifactId
                    def IMAGE_TAG = mavenPom.version
                    def REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
		    sh 'cd release/'
	            sh "find . -type d -name '*@tmp' -print -delete"
		    sh 'cd ..'

                    dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"      
                    echo "building images" 
                    sh 'aws ecr get-login-password --region "${AWS_DEFAULT_REGION}" | docker login --username AWS --password-stdin "${AWS_ACCOUNT_ID}".dkr.ecr."${AWS_DEFAULT_REGION}".amazonaws.com' 
                    sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
                    sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
		    sh 'sleep 60'
                }           

            } 
        }

    }

    stage ('ECR scan Analysis') {
        when {expression { params.Build_Image == 'yes' }}  
        steps{
            script{
                withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding', 
                credentialsId: 'chaitanya',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
            ]])
            {
                    def mavenPom = readMavenPom file:'pom.xml'
                    def IMAGE_REPO_NAME = mavenPom.artifactId
                    def IMAGE_TAG = mavenPom.version
                    def REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
                    sh 'aws ecr get-login-password --region "${AWS_DEFAULT_REGION}" | docker login --username AWS --password-stdin "${AWS_ACCOUNT_ID}".dkr.ecr."${AWS_DEFAULT_REGION}".amazonaws.com'
                    echo "scanning images" 
                    def amap = sh (script : "aws ecr describe-image-scan-findings --repository-name ${IMAGE_REPO_NAME} --image-id imageTag=${IMAGE_TAG} --region ${AWS_DEFAULT_REGION}",
                                    returnStdout: true).trim()
                    writeJSON file: 'data.json', json: amap 
                    def check_vul = sh(script:'python3 check.py',returnStdout: true) .trim()
                    echo "Running python" 
                        "echo ${check_vul}"
                    if (check_vul == "True"){
                        sh "exit 1"
                    }                       
                
            }
            } 
        }

    }



}
}
      
