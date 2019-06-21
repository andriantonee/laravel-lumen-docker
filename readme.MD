# Configuring

Copy .env.example and rename it to .env

Modify .env with your own environment

# Running Docker Container

Run Command:

    docker-compose up -d

If you change Dockerfile, and want to apply it:

    docker-compose up -d --build

If running using docker and got error [failed to open stream - Permission denied](https://stackoverflow.com/questions/50552970/laravel-docker-the-stream-or-file-var-www-html-storage-logs-laravel-log-co)

# Stop Running Docker Container

Stop Command:

    docker-compose down

# Deploying

Global Prerequirement:
* make sure your aws account have a permission for [ecr](../master/ecr-policy.json) and [ecs](../master/ecs-policy.json)
* if ecsTaskExecutionRole role does not exists. [follow this guide](https://docs.aws.amazon.com/en_us/AmazonECS/latest/developerguide/task_execution_IAM_role.html)
* modify **_FILL_WITH_YOUR_AWS_SUBNET_** and **_FILL_WITH_YOUR_AWS_SECURITY_GROUP_** from this [file](../master/ecs-params.yml)
* modify **_FILL_WITH_YOUR_AWS_TARGET_GROUP_ARN_** with **application load balancer** target group from this [file](../master/.gitlab-ci.yml)

Prerequirement Using Gitlab CI/CD Pipeline:
* set secret variable in CI/CD. The variable is located at **_docker-compose.deploy.yml_**, **_Makefile_** and  **_.gitlab-ci.yml_**
