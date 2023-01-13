.PHONY: dev-init
dev-init:
	serverless plugin install -n serverless-localstack &&\
	serverless plugin install -n serverless-step-functions

dev-start:
	docker-compose down && docker-compose up -d && make dev-deploy && make dev-push-lambdas && docker-compose logs -f

dev-deploy:
	serverless deploy --stage local

dev-push-lambdas:
	npm run build && npm run export &&\
	awslocal lambda --region us-west-1 update-function-code --function-name task-runner-local-addTask --zip-file fileb://build/main.js.zip && \
	awslocal lambda --region us-west-1 update-function-code --function-name task-runner-local-pullQueuedTasksByUserId --zip-file fileb://build/main.js.zip && \
	awslocal lambda --region us-west-1 update-function-code --function-name task-runner-local-pullFirstTask --zip-file fileb://build/main.js.zip


dev-get-links:
	awslocal lambda create-function-url-config \
        --region us-west-1 \
        --function-name task-runner-local-addTask \
        --auth-type NONE &&\
	awslocal lambda create-function-url-config \
        --region us-west-1 \
        --function-name task-runner-local-pullQueuedTasksByUserId \
        --auth-type NONE &&\
  	awslocal lambda create-function-url-config \
            --region us-west-1 \
            --function-name task-runner-local-pullFirstTask \
            --auth-type NONE \
        | grep FunctionUrl

dev-list-sms:
	awslocal stepfunctions --region us-west-1  list-executions --state-machine arn:aws:states:us-west-1:000000000000:stateMachine:orchestratorStateMachine

.PHONY: dev-start-sm
dev-start-sm:
	awslocal stepfunctions --region us-west-1 start-execution --state-machine arn:aws:states:us-west-1:000000000000:stateMachine:orchestratorStateMachine --name ${name}

dev-addTask:
	serverless invoke local --stage local --function addTask --data {"body":{"context": "test"}}

dev-firstTask:
	serverless invoke local --stage local --function pullFirstTask

dev-list-tables:
	AWS_REGION=us-west-1 awslocal dynamodb list-tables

dev-pull-pending-tasks:
	serverless invoke local --stage local --function pullQueuedTasksByUserId --data '{"user_id": "${user_id}"}'


dev-user-tasks:
	awslocal stepfunctions --region us-west-1 start-execution --state-machine arn:aws:states:us-west-1:000000000000:stateMachine:userTasksStateMachine --name ${name} --input "{\"user_id\":\"${user_id}\"}"