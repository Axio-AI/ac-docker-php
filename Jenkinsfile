safeNode('arm64-docker-large') {
  stage('Checkout') {
    checkout scm
  }

  stage('Build') {
    sh """
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 267547548852.dkr.ecr.us-east-1.amazonaws.com

    export VERSION=\$(cat VERSION)

    docker build --tag 267547548852.dkr.ecr.us-east-1.amazonaws.com/docker/php:\${VERSION}-arm .
    if [ "$GERRIT_EVENT_TYPE" = "change-merged" ]; then
      docker push 267547548852.dkr.ecr.us-east-1.amazonaws.com/docker/php:\${VERSION}-arm
    fi
    """
  }
}

safeNode('amd64-docker-large') {
  stage('Checkout') {
    checkout scm
  }

  stage('Build') {
    sh """
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 267547548852.dkr.ecr.us-east-1.amazonaws.com

    export VERSION=\$(cat VERSION)-amd64

    docker build --tag 267547548852.dkr.ecr.us-east-1.amazonaws.com/docker/php:\${VERSION}-amd .
    if [ "$GERRIT_EVENT_TYPE" = "change-merged" ]; then
      docker push 267547548852.dkr.ecr.us-east-1.amazonaws.com/docker/php:\${VERSION}-amd
    fi
    """
  }
}

safeNode('arm64-docker-large') {
  stage('Checkout') {
    checkout scm
  }

  stage('Update Manifest') {
    sh """
    if [ "$GERRIT_EVENT_TYPE" = "change-merged" ]; then
      docker manifest create \
        267547548852.dkr.ecr.us-east-1.amazonaws.com/docker/php:\$VERSION \
        --amend 267547548852.dkr.ecr.us-east-1.amazonaws.com/docker/php:\${VERSION}-arm \
        --amend 267547548852.dkr.ecr.us-east-1.amazonaws.com/docker/php:\${VERSION}-amd
    fi
    """
  }
}
