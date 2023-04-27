set -eo pipefail

echo "Authenticating with Salesforce CLI"
echo $SALESFORCE_JWT_KEY > jwt.key
sfdx force:auth:jwt:grant -i $APP_KEY -f keys/server.key --username $SF_USERNAME --setdefaultdevhubusername

echo "Creating scratch org"
sfdx force:org:create -f config/project-scratch-def.json -a scratch-org -s

echo "Deploying metadata to scratch org"
sfdx force:source:deploy --sourcepath force-app/main/default --targetusername scratch-org --wait 10

echo "Running Apex tests"
sfdx force:apex:test:run -u scratch-org -w 5

echo "Deleting scratch org"
sfdx force:org:delete -p -u scratch-org
