#!/usr/bin/env groovy

/*
Description:
This Jenkinsfile contains one 'stage', in which it performs several actions
on any Jenkins slave
*/

// need to ensure the docker tag used in the Makefile is lowercase
env.DOCKER_TAG = BUILD_TAG.toLowerCase()

node {
  // Checkout the repository branch/tag/commit which triggered this job into the
  // Jenkins node workspace
  stage('Test') {
    checkout scm

    // Run the Makefile steps
    sh 'make'
  }
}

if (env.BRANCH_NAME == 'master') {
  node {
    stage('Dev') {
      checkout scm

      withCredentials([usernamePassword( credentialsId: 'inseason-dev', usernameVariable: 'AWS_ACCESS_KEY', passwordVariable: 'AWS_SECRET_KEY')]) {
        // Run the Makefile steps
        sh 'make deploy-dev'
      }
    }
  }

  stage('Promotion to production') {
    timeout(time: 60) {
      input message: "Proceed with deployment to production?"
    }
  }
  node {
    stage('Prod') {
      checkout scm

      withCredentials([usernamePassword( credentialsId: 'inseason-prod', usernameVariable: 'AWS_ACCESS_KEY', passwordVariable: 'AWS_SECRET_KEY')]) {
        // Run the Makefile steps
        sh 'make deploy-prod'
      }
    }
  }
}
