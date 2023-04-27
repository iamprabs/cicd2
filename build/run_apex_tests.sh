set -eo pipefail

echo "Authenticating with Salesforce CLI"
echo $SALESFORCE_JWT_KEY > jwt.key
sfdx force:auth:jwt:grant --clientid $APP_KEY --jwtkeyfile keys/server.key --username $SALESFORCE_USERNAME --setdefaultdevhubusername

echo "Creating scratch org"
sfdx force:org:create -f config/project-scratch-def.json -a scratch-org -s

echo "Deploying metadata to scratch org"
sfdx force:source:deploy -p force-app/main/default -u scratch-org

echo "Running Apex tests"
sfdx force:apex:test:run -u scratch-org -w 5

echo "Deleting scratch org"
sfdx force:org:delete -p -u scratch-org
