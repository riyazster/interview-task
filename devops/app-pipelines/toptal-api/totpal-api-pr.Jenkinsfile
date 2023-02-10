#!/usr/bin/env groovy
/*Pipeline Utility Steps  plugin is required */
def podyaml = """
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: toptal
spec:
  containers:
    - name: node
      image: node
      command:
        - cat
      tty: true
  """

pipeline {
    agent {
        kubernetes {
            yaml "${podyaml}"
            defaultContainer "node"
        }
    }
    parameters {
        string name: 'payload', trim: true
    }    
    stages {
        stage('GitClone') {
            steps {
                script {
                    String payload = "${payload}"
                    jsonObject = readJSON text: payload
                    println "my data is ${jsonObject.pull_request.head.ref}"
                    gitHash = "${jsonObject.pull_request.head.sha}"
                    String gitUrl = "${jsonObject.repository.clone_url}"
                    checkout([$class: 'GitSCM', branches: [[name: "${gitHash}"]], 
                    doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], 
                    userRemoteConfigs: [[credentialsId: 'git_token', url: "${gitUrl}"]]])                    
                }
            }
        }
        stage("Get Dependencies"){
            steps {
                script {
                    sh """
                    npm install
                    """
                }
            }
        }
        // stage('Unit Test') {
        //     steps {
        //         script {
        //             sh """
        //                 npm test
        //             """
        //         }
        //     }

        // }        
        // stage('CodeQuality') {
        //     steps {
        //         container('sonar'){
        //             script {
        //                 withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
        //                     // some block
        //                     sh """
        //                     sonar-scanner \
        //                     -Dsonar.projectKey="toptal-api"  \
        //                     -Dsonar.sources="/tmp/dir"   \
        //                     -Dsonar.host.url="https://sonarcloud.io" \
        //                     -Dsonar.branch.target="master" \
        //                     -Dsonar.branch.name="${jsonObject.pull_request.head.ref}" \
        //                     -Dsonar.login="$SONAR_TOKEN" \
        //                     -Dsonar.organization="toptal-interview"
        //                     """
        //                 }
        //             }
                    

        //         }
        //     }

        // }
    }
}
