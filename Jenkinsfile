pipeline {
    agent { label "openvpn"  }
    
    stages {
        stage('Read user metadata') {
            steps {
                script {
                    wrap([$class: 'BuildUser']) {
                       env.BUILD_USER_EMAIL = BUILD_USER_EMAIL
                       currentBuild.description = ( action + ': ' + env.BUILD_USER_EMAIL )
                    }   
                }
            }
        }
        stage('Run script') {
            steps {
                script {
                   env.password = sh returnStdout: true, script: 'pwgen -1 32'

                   sh '''#!/bin/bash
                       export PATH=${PATH}:${WORKSPACE}

                       if ( ./expect.sh list | grep $BUILD_USER_EMAIL ); then
                           ./expect.sh revoke ${BUILD_USER_EMAIL}                         
                       fi

                       ./expect.sh create ${BUILD_USER_EMAIL} ${password}
                   '''
                }
            }
        }
    }


    post {
      success {
           script {
               ws('/root') {
                 emailext attachmentsPattern: "${BUILD_USER_EMAIL}.ovpn", body: 'Password: ' + env.password, 
                    subject: "Jenkins: openvpn config", 
                    mimeType: 'text/html',to: BUILD_USER_EMAIL
               }
           }
      }
    }

}
