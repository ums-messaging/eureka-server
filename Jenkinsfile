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
                    sshagent(['ums']) {
                         sh """
                            if [ ! -d .git ]; then
                                git init
                                git remote add origin git@github.com:ums-messaging/eureka-server.git
                                git pull origin $GIT_BRANCH
                            else
                                git fetch origin $GIT_BRANCH
                                git checkout $GIT_BRANCH
                                git pull origin $GIT_BRANCH
                            fi
                         """
                    }
                 }
            }
        }
        stage('Gradle Build') {
            steps {
                script {
                    sh 'nohup aws ssm start-session --target i-00464ff35252824cb --document-name AWS-StartPortForwardingSession --parameters "portNumber=8081,localPortNumber=8081" > ~/ssm-session.log 2>&1 &'
                    sh 'chmod +x gradlew'
                    sh './gradlew build --refresh-dependencies'
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t ${REGISTRY}/${APP_NAME}:${IMAGE_TAG} .
                    docker ${REGISTRY} --username jang314 --password jang314
                    docker push ${REGISTRY}/${APP_NAME}:${IMAGE_TAG}
                '''
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
