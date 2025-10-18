pipeline {
    agent any

    environment {
        REGISTRY = "registry.ums.local:5000"
        APP_NAME = "eureka-server"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        DEPLOY_HOST = "10.0.0.134"
        SSH_KEY = "ums-key.pem"
        GIT_BRANCH = "${env.BRANCH_NAME ?: 'main'}"
    }

    stages {
        stage('Checkout Eureka Server') {
            steps {
                 script {
                    def branch = env.BRANCH_NAME ?: 'main'
                    sshagent(['github-ssh-key']) {
                        sh "git clone -b ${branch} git@github.com:ums-messaging/eureka-server.git"
                    }
                 }
            }
        }

        stage('Gradle Build') {
            steps {
                script {
                    sh 'chmod +x gradlew'
                    sh './gradlew clean build --offline '
                }
            }
        }
    }

    post {
        failure {
            echo "❌ 빌드 또는 배포 실패!"
        }
        success {
            echo "✅ 전체 파이프라인 완료!"
        }
    }
}
