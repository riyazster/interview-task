#!/usr/bin/env groovy
/* Make sure you are configuring kubectl plugin */
def podyaml = """
apiVersion: v1
kind: Pod
metadata:
  name: kaniko
spec:
  containers:
  - name: kubelet
    image: dtzar/helm-kubectl
    imagePullPolicy: Always
    command:
    - cat
    tty: true
  """
def registryrepo = "shan5a6"
def namespace = "toptal"
def configpath = "./devops/app-configs"
def clusterurl = "https://2ED56CC1C4C46A4C547343E6CA49A044.gr7.us-east-1.eks.amazonaws.com"

pipeline {
    agent {
        kubernetes {
            yaml "${podyaml}"
            defaultContainer "kubelet"
        }
    }
    parameters {
        choice(name: 'environment', choices: ['dev', 'sit', 'prod'], description: 'Environment to deploy')
        choice(name: 'servicename', choices: ['toptal-api', 'toptal-web'], description: 'Select service to deploy')
        string(name: 'version', defaultValue: '0.0.0', description: 'version to deploy') 
        
    } 
  stages {
        stage('printing inputs') {
            steps {
                script {
                    println "env is ${params.environment},version selected is ${params.version}" 
                    println "Selected namespace is ${namespace}-${params.environment} && service name is ${params.servicename}" 
                }
                
            }
        }
        stage('GitClone') {
            steps {
                    script {
                        checkout([$class: 'GitSCM', branches: [[name: "master"]], 
                        doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], 
                        userRemoteConfigs: [[credentialsId: 'git_token', url: "https://github.com/shan5a6/partime.git"]]])
                }

            }
        }  
      
        stage('Sync Configmaps') {
            steps {
                    script {
                        withKubeConfig([credentialsId: 'eks-token',serverUrl: "${clusterurl}"]) {
                            sh """
                                ls -l ${configpath}/${namespace}-${params.environment}/configmaps/
                                kubectl apply  -Rf ${configpath}/${namespace}-${params.environment}/configmaps/
                            """
                            }
                }

            }
        } 
        stage('Sync Deploymentconfigs') {
            steps {
                    script {
                        withKubeConfig([credentialsId: 'eks-token',serverUrl: "${clusterurl}"]) {
                            sh """
                                kubectl apply  -Rf ${configpath}/${namespace}-${params.environment}/deploymentconfigs/${params.servicename}.yaml
                            """
                            }
                }

            }
        }  

        stage('Patch deployment') {
            steps {
                script {
                    withKubeConfig([credentialsId: 'eks-token',serverUrl: "${clusterurl}"]) {
                        sh """
                        kubectl set image deployment/${params.servicename} ${params.servicename}="${registryrepo}/${params.servicename}:${params.version}" -n "${namespace}-${params.environment}"
                        """
                    }
                    }
                }

            }                      

        stage('Restart deployment') {
            steps {
                script {
                        withKubeConfig([credentialsId: 'eks-token',serverUrl: "${clusterurl}"]) {
                            sh """
                            kubectl rollout restart deploy ${params.servicename} -n ${namespace}-${params.environment}
                            """
                        }
                    }
                }
        }    
    }

}
