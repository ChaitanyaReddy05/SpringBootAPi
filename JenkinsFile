pipeline {
    agent any 
    tools{
         maven 'maven5'
       }
    stages {
      stage ('Build phase') {
      
      steps{
          sh script: 'mvn clean package'      
      }
      
      }
        }
}
