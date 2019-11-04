# List ENV

* APP_NAME (**_GLOBAL_**, set to your-app-name)
* APP_ENV (set in gitlab.ci.yml)
* APP_KEY
* APP_DEBUG
* DB_CONNECTION
* DB_HOST
* DB_PORT
* DB_DATABASE
* DB_USERNAME
* DB_PASSWORD

# Development

Config:

1. Copy .env.example and rename it to .env
2. Modify .env with your own environment
3. If project location is outside of the root folder (for local development only):  
	by default `DOCKER_USER=0`
    ```
    export DOCKER_USER=$(id -u):$(id -g)
    ```
4. To change docker host:  
	by default `DOCKER_HOST=80`
	```
	export DOCKER_HOST=xxxx
	```
	or
	```
	export DOCKER_HOST=xxx.xxx.xx.xx:xxxx
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

EC2 Setup for Docker:
1. Launch EC2 Instance.
2. SSH to new created server.
    * Install [docker](https://docs.docker.com/install/), git
    * Make sure your docker will start automatically if system reboot
    * Configure git in ssh server (https://docs.gitlab.com/ee/ssh/#generating-a-new-ssh-key-pair)
		```
        ssh-keygen -o -t rsa -b 4096
        ```
	* Read rsa pub key, using cat command.
		```
        cat .ssh/id_rsa.pub
        ```
	* Git clone the project (choose your name wisely because this will be used in gitlab-ci.yml file for automation purpose -> **SSH_DEV_PROJECT_PATH**)

# Deploy

Gitlab CI/CD Jobs (deploy-development):
1. Go to Gitlab Project > Settings > CI / CD > Variables
2. Set [ENV](#list-env) with prefix ENV_DEV_ exclude **_GLOBAL_**
3. Set:
	* SSH_DEV_PRIVATE_KEY
	* SSH_DEV_URL
	* SSH_DEV_USER
	* SSH_DEV_PROJECT_PATH
4. Every push to branch master will create a new pipeline (trigger the deploy-development job manually)

Gitlab CI/CD Jobs (build and deploy-production):
1. Create ecsTaskExecutionRole role if does not exists ([follow this guide](https://docs.aws.amazon.com/en_us/AmazonECS/latest/developerguide/task_execution_IAM_role.html))
2. Go to Gitlab Project > Settings > CI / CD > Variables
3. Set [ENV](#list-env) with prefix ENV_PROD_ exclude **_GLOBAL_**
4. Set:
	* ECS_PROD_ACCESS_KEY_ID
	* ECS_PROD_SECRET_ACCESS_KEY
	* ECS_PROD_REGION
	* ECR_PROD_SITE_APP
	* ECR_PROD_WEB_SERVER
	* ECS_PROD_SUBNET_1 (if you want to add more subnet, you need to modify the gitlab.ci.yml config)
	* ECS_PROD_TARGET_GROUP_ARN
4. Every push to branch master will create a new pipeline (build will be executed automatically, to deploy production you need to trigger the deploy-production job manually)
