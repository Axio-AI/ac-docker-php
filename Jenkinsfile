def cleanupNode() {
  sh """
  docker kill \$(docker ps -q) || true
  docker system prune -af --volumes
  rm -rf $WORKSPACE/*
  """
}

stage('Abort Previous Builds') {
  while(currentBuild.rawBuild.getPreviousBuildInProgress() != null) {
    currentBuild.rawBuild.getPreviousBuildInProgress().doKill()
  }
}

node('arm64-docker-large') {
  stage('Cleanup Node') {
    cleanupNode()
  }

  stage('Checkout') {
    checkout scm
  }

  stage('Build') {
    sh """
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 267547548852.dkr.ecr.us-east-1.amazonaws.com

    export VERSION=\$(cat VERSION)

    docker build --tag 267547548852.dkr.ecr.us-east-1.amazonaws.com/docker/notebowl/php:\$VERSION .
    docker push 267547548852.dkr.ecr.us-east-1.amazonaws.com/docker/notebowl/php:\$VERSION
    """
  }
}
