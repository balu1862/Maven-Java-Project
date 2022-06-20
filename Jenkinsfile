
pipeline {
    agent any

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "M2_HOME"
    }

    stages {
        stage('Prepare-Workspace') {
            steps {
                // Get some code from a GitHub repository
                git credentialsId: 'github-server-credentials', url: 'https://github.com/balu1862/Maven-Java-Project.git'    
		stash 'Source'
            }
            
        }

	    
 
      stage('Build Code') {
        
          steps{
	      unstash 'Source'
              sh "mvn clean package"  
          }
      }
	    
      stage('Build Docker Image') {
         
         steps{
                  sh "docker build -t balu2143/webapp1 ."  
         }
     }
	    
     stage('Publish Docker Image') {
         
        steps{

    	      withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'dockerPassword', usernameVariable: 'dockerUser')]) {
    		    sh "docker login -u ${dockerUser} -p ${dockerPassword}"
	      }
        	sh "docker push balu2143/webapp1"
         }
    }
	    
     stage('Deploy to Staging') {
	
	steps{
	      //Deploy to K8s Cluster 
              echo "Deploy to Staging Server"
	      sshCommand remote: kops, command: "cd Maven-Java-Project; git pull"
	      sshCommand remote: kops, command: "kubectl delete -f Maven-Java-Project/k8s-code/staging/app/deploy-webapp.yml"
	      sshCommand remote: kops, command: "kubectl apply -f Maven-Java-Project/k8s-code/staging/app/."
	}		    
    }
	    
     stage ('Integration-Test') {
	
	steps {
             echo "Run Integration Test Cases"
             unstash 'Source'
            sh "mvn clean verify"
        }
    }
	    
    stage ('approve') {
	steps {
		echo "Approval State"
                timeout(time: 7, unit: 'DAYS') {                    
			input message: 'Do you want to deploy?', submitter: 'admin'
		}
	}
     }
	    
     stage ('Prod-Deploy') {
	
	steps{
              echo "Deploy to Production"
	      //Deploy to Prod K8s Cluster
	      sshCommand remote: kops, command: "cd Maven-Java-Project; git pull"
	      sshCommand remote: kops, command: "kubectl delete -f Maven-Java-Project/k8s-code/prod/app/deploy-webapp.yml"
	      sshCommand remote: kops, command: "kubectl apply -f Maven-Java-Project/k8s-code/prod/app/."
	}
	}

    }
}
