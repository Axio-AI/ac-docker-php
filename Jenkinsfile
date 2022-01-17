stage('Abort Previous Builds') {
  abortPreviousBuilds()
}

safeNode('arm64-docker-large') {
  stage('Checkout') {
    checkout scm
  }

  stage('Build') {
    sh """
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 267547548852.dkr.ecr.us-east-1.amazonaws.com

    export VERSION=\$(cat VERSION)

    docker build --tag 267547548852.dkr.ecr.us-east-1.amazonaws.com/docker/notebowl/php:\$VERSION .
    if [ "$GERRIT_EVENT_TYPE" = "change-merged" ]; then
      docker push 267547548852.dkr.ecr.us-east-1.amazonaws.com/docker/notebowl/php:\$VERSION
    fi
    """
  }
}
