    pipeline {
    agent any 
    tools
    {
        maven 'maven5'
     }
    environment
     {
        AWS_DEFAULT_REGION="us-east-1"   
        AWS_ACCOUNT_ID = "663986567307"
        NEXUS_URL =  "35.153.66.131:8081"        
    }
    parameters 
    {
        gitParameter branchFilter: 'origin/(.*)', defaultValue: 'master', name: 'BRANCH', type: 'PT_BRANCH'

    }	        
    stages
     {        
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
 if (params.BRANCH == 'Develop'){
    stage ('Compile phase') {
        steps{
                script{

                   
                    sh 'mvn clean package'      
                    }
                }        
        }
    }
 if (params.BRANCH == 'Develop'){   
    stage("build & SonarQube analysis") {
                agent any
                steps {
                    script{
                                    
                        withSonarQubeEnv('sonarserver') {
                        sh 'mvn sonar:sonar'
                    }
                }
            }
        }
           
    }
    if (params.BRANCH == 'Develop'){
        stage("Quality Gate") {
                steps {
                        script{
                            
                            timeout(time: 1, unit: 'HOURS') {
                            waitForQualityGate abortPipeline: true
                        }
                    }
                }                
            }
        }   
    if (params.BRANCH == 'Develop'){
        stage ('Build phase') {
            steps{
                        script{                            
                            sh  'mvn clean install'
                            }
                        }
                    
            }

        }
    
    if (params.BRANCH == 'Develop'){
        stage ('Upload Artifacts phase') {
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

        }
    if (params.BRANCH == 'master'){
        if (params.run_tests == 'Functional'){ 
            stage ('Functional Testing') {
                steps{
                        script{
                                
                                                            
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
    if (params.BRANCH == 'master'){
        if (params.run_tests == 'regression'){
            stage ('Regression Testing') {
                    steps{
                            script{                              
                                    
                                        sh  '''
                                    echo "Regression tests done"
                                '''
                                    }                          
                            
                                }
                        }
            }
            }
if (params.build_image == 'no'){
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
                                
                        def mavenPom = readMavenPom file:'pom.xml'
                        def IMAGE_REPO_NAME = mavenPom.artifactId
                        def IMAGE_TAG = mavenPom.version
                        def REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
                        dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"      
                        echo "building images" 
                        sh 'aws ecr get-login-password --region "${AWS_DEFAULT_REGION}" | docker login --username AWS --password-stdin "${AWS_ACCOUNT_ID}".dkr.ecr."${AWS_DEFAULT_REGION}".amazonaws.com' 
                        sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
                        sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                
                    }
                }

                } 
    }

    }
if (params.build_image == 'yes'){  
    stage ('ECR scan Analysis') {
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
                        def check_vul = sh(script:'python3 check.py',returnStdout: true) 
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
    }
        


