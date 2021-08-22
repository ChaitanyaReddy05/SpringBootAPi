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
}
}


