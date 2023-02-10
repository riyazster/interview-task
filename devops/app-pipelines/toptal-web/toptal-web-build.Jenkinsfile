#!/usr/bin/env groovy
/* Dont forget to create the  docker credentials in devops-tools namespace 
docker --config /tmp login https://index.docker.io/v1/
kubectl create secret generic dockersecret --from-file=/tmp/config.json -n devops-tools
*/
def podyaml = """
apiVersion: v1
kind: Pod
metadata:
  name: kaniko
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: Always
    command:
    - /busybox/cat
    tty: true
    volumeMounts:
      - name: jenkins-docker-cfg
        mountPath: /kaniko/.docker
  volumes:
  - name: jenkins-docker-cfg
    projected:
      sources:
      - secret:
          name: dockersecret
          items:
            - key: config.json
              path: config.json
  """

pipeline {
    agent {
        kubernetes {
            yaml "${podyaml}"
            defaultContainer "kaniko"
        }
    }
    stages {
        stage('GitClone') {
            steps {
                    script {
                        checkout([$class: 'GitSCM', branches: [[name: "master"]], 
                        doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], 
                        userRemoteConfigs: [[credentialsId: 'git_token', url: "https://github.com/shan5a6/totpal-web.git"]]])
                }

            }
        }
        stage("readversion"){
            steps {
                script {
                    version_parser = readJSON file: './package.json'
                    image_version = "${version_parser.version}"
                    println "my app version is ${image_version}"
                }
            }
        }

        stage("build&pushimage"){
            environment {
                PATH        = "/busybox:$PATH"
                REGISTRY    = 'index.docker.io' // Configure your own registry
                REPOSITORY  = 'shan5a6'
                IMAGE       = 'toptal-web'
                TAG         = "${image_version}"

            }               
            steps {
                script{

                    sh """
                    /kaniko/executor -f `pwd`/Dockerfile -c `pwd` --cache=true --destination=${REGISTRY}/${REPOSITORY}/${IMAGE}:${TAG}
                    """

                }
            }
        }

    }
}        
