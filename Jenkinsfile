podTemplate(
  serviceAccount: "deployment-sa",
  containers: [
    containerTemplate(name: 'kubectl', image: "bitnami/kubectl", command: 'sleep', args: '99d', ttyEnabled: true),
    containerTemplate(name: 'kaniko', image: 'gcr.io/kaniko-project/executor:debug', command: 'sleep', ttyEnabled: true, args: '99d')
  ],
  volumes: [configMapVolume(mountPath: '/kaniko/.docker', configMapName: 'github-credentials')]
){
  node(POD_LABEL){
    stage('Checkout Source') {
      container('kaniko') {
        git branch: 'main', url: 'https://github.com/souzaxx/devops-assessment.git'
      }
    }

    stage('Build image') {
      container('kaniko') {
        sh "/kaniko/executor --context ${WORKSPACE}/sample-service --dockerfile ${WORKSPACE}/sample-service/Dockerfile --destination=souzaxx/sample-service:${BUILD_NUMBER}"
      }
    }

    stage('Deploy') {
      container('kubectl') {
        withKubeConfig() {
          sh "kubectl set image deployment/sample-service-deployment sample-service-container=souzaxx/sample-service:${BUILD_NUMBER} --namespace prod"
          sh "kubectl rollout status deployment sample-service-deployment --namespace prod"
        }
      }
    }
  }
}