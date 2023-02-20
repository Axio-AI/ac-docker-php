def withBuildContext(label, Closure c) {
  safeNode(label) {
    checkout scm

    withDockerCredentials {
      def version = sh(script: "cat VERSION", returnStdout: true).trim()

      withEnv([
        "VERSION=${version}"
      ]) {
        c()
      }
    }
  }
}

def jobs = [:]

jobs["amd"] = {
  withBuildContext('amd64-docker-large') {
    sh "docker build --tag activeclass/php:\${VERSION}-amd64 ."

    if (isChangeMerged()) {
      sh "docker push activeclass/php:\${VERSION}-amd64"
    }
  }
}

jobs["arm"] = {
  withBuildContext('arm64-docker-large') {
    sh "docker build --tag activeclass/php:\${VERSION}-arm64 ."

    if (isChangeMerged()) {
      sh "docker push activeclass/php:\${VERSION}-arm64"
    }
  }
}

stage('Build') {
  parallel jobs
}

if (isChangeMerged()) {
  stage('Update Manifest') {
    withBuildContext('arm64-docker-large') {
      sh """
        docker manifest create \
          activeclass/php:\${VERSION} \
          --amend activeclass/php:\${VERSION}-arm64 \
          --amend activeclass/php:\${VERSION}-amd64

        docker manifest push activeclass/php:\${VERSION}
      """
    }
  }
}
