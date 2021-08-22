pipeline {
agent any 
tools{
 maven 'maven5'
}
 environment {
  AWS_DEFAULT_REGION = 'us-east-1'
  
 }
stages {

   stage ('Compile phase') {

steps{
 script {
    withCredentials([[
        $class: 'AmazonWebServicesCredentialsBinding', 
        credentialsId: 'chaitanya',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
    ]]) {
        sh 'aws ec2 describe-instances'
    }
}
   }
}
}
}

