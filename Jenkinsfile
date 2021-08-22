pipeline {
agent any 
tools{
 maven 'maven5'
}
 environment {
  my_aws_creds = credentials('chaitanya')
  
 }
stages {

   stage ('Compile phase') {

steps{
  sh '''
  aws --version
  aws ec2 describe-instances
  python3 --version
  '''      
}
   }
}
}


