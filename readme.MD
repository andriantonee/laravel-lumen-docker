# List ENV

* APP_NAME
* APP_ENV
* APP_KEY
* APP_DEBUG
* DB_CONNECTION
* DB_HOST
* DB_PORT
* DB_DATABASE
* DB_USERNAME
* DB_PASSWORD

# Develops

Config:

1. Copy .env.example and rename it to .env
2. Modify .env with your own environment
3. If project location is outside of the root folder:
    ```
    export DOCKER_USER=$(id -u):$(id -g)
    ```

Run Command:
```
docker-compose up -d
```

If you change Dockerfile, and want to apply it:
```
docker-compose up -d --build
```

~~If running using docker and got error from laravel [failed to open stream - Permission denied](https://stackoverflow.com/questions/50552970/laravel-docker-the-stream-or-file-var-www-html-storage-logs-laravel-log-co)~~ => Solved using LOG_CHANNEL=stderr, do not run chmod to the project folder (your git will get so messy)

Stop Command:

    docker-compose down

# Deploy

Gitlab CI/CD Jobs (deploy-development):
1. Go to Gitlab Project > Settings > CI / CD > Variables
2. Set [ENV](#list-env) with prefix ENV_DEV except APP_NAME
3. Set **SSH_DEV_PRIVATE_KEY**, **SSH_DEV_URL**, **SSH_DEV_USER**
4. Every push to branch master will create a new pipeline (trigger the deploy-development job manually)

Gitlab CI/CD Jobs (deploy-production):
1. Create ecsTaskExecutionRole role if does not exists ([follow this guide](https://docs.aws.amazon.com/en_us/AmazonECS/latest/developerguide/task_execution_IAM_role.html))
2. Edit **_FILL_WITH_YOUR_AWS_SUBNET_** and **_FILL_WITH_YOUR_AWS_SECURITY_GROUP_** (ecs-params.yml)
3. Edit **_FILL_WITH_YOUR_AWS_TARGET_GROUP_ARN_** with **application load balancer** target group (gitlab-ci.yml)
4. Go to Gitlab Project > Settings > CI / CD > Variables
5. Set [ENV](#list-env) with prefix ENV_PROD except APP_NAME
6. Set **ECS_PROD_ACCESS_KEY_ID**, **ECS_PROD_SECRET_ACCESS_KEY**, **ECR_PROD_SITE_APP**, **ECR_PROD_WEB_SERVER**, **ECS_PROD_REGION** => make sure your account have a permission for ECR (ecr-policy.json) and ECS (ecs-policy.json)
7. Every push to branch master will create a new pipeline (trigger the deploy-production job manually)

Deploy manually:
1. Install Docker Version: **18.09.6**
2. Set [ENV](#list-env)
3. Run **_deploy_** script to run container
