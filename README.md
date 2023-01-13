Requirements:
- Docker https://docs.docker.com/desktop/install/mac-install/  
- localstack
    ```shell
    brew install localstack
    ```
- node:
    ```shell
    brew install node@12
    ```
  or try to use nvm and do
    ```shell
    nvm install 12
    nvm use 12
    ```
- serverless
    ```shell
    npm install -g serverless
    ```
  

Start local Dev Env


```shell
make dev-init && make dev-start
```

On another shell run this to get urls:
```shell
make dev-
```

Copy the url of addTask and replace it here:
```shell
curl --location --request POST 'http://eee9865e8961215c47ce2e8c1192f5d5.lambda-url.us-west-1.localhost.localstack.cloud:4566/' \
--header 'Content-Type: application/json' \
--data-raw '{
    "priority": 0,
    "task_id": 1,
    "user_id": 1,
    "context": {
      "name": "test 1"
    }
}'
```
You should be able to post tasks

Once you post few tasks, you can run:
```shell
make dev-start-sm name=01
```

Run this to see the status of the state machine execution
```shell
make dev-list-sms
```

Test UserTasks State Machine
```shell
make dev-user-tasks name=04 user_id=1
```