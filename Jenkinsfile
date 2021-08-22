pipeline {
agent any 
tools{
 maven 'maven5'
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


