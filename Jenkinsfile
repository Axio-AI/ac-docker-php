safeNode('arm64-docker-large') {
  stage('Checkout') {
    checkout scm
  }

  stage('Build ARM64') {
    sh """
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 267547548852.dkr.ecr.us-east-1.amazonaws.com

    export VERSION=\$(cat VERSION)-arm64

    docker build --tag 267547548852.dkr.ecr.us-east-1.amazonaws.com/docker/php:\${VERSION} .
    if [ "$GERRIT_EVENT_TYPE" = "change-merged" ]; then
      docker push 267547548852.dkr.ecr.us-east-1.amazonaws.com/docker/php:\${VERSION}
    fi
    """
  }
}

safeNode('amd64-docker-large') {
  stage('Checkout') {
    checkout scm
  }

  stage('Build AMD64') {
    sh """
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 267547548852.dkr.ecr.us-east-1.amazonaws.com

    export VERSION=\$(cat VERSION)-amd64

    docker build --tag 267547548852.dkr.ecr.us-east-1.amazonaws.com/docker/php:\${VERSION} .
    if [ "$GERRIT_EVENT_TYPE" = "change-merged" ]; then
      docker push 267547548852.dkr.ecr.us-east-1.amazonaws.com/docker/php:\${VERSION}
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
      aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 267547548852.dkr.ecr.us-east-1.amazonaws.com
      export VERSION=\$(cat VERSION)

    if [ "$GERRIT_EVENT_TYPE" = "change-merged" ]; then
      docker manifest create \
        267547548852.dkr.ecr.us-east-1.amazonaws.com/docker/php:\${VERSION} \
        --amend 267547548852.dkr.ecr.us-east-1.amazonaws.com/docker/php:\${VERSION}-arm64 \
        --amend 267547548852.dkr.ecr.us-east-1.amazonaws.com/docker/php:\${VERSION}-amd64

      docker manifest push 267547548852.dkr.ecr.us-east-1.amazonaws.com/docker/php:\${VERSION}
    fi
    """
  }
}
