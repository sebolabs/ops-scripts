#!/usr/bin/env bash

# ================ ~/.aws/config entry example ================
# [profile profile-name]
# sso_start_url = https://d-XXXXXXXXXX.awsapps.com/start
# sso_region = eu-central-1
# sso_account_id = 012345678910
# sso_role_name = AWSAdministratorAccess
# region = eu-central-1
# output = json
# =============================================================

SSO_CACHE_PATH="~/.aws/sso/cache"
DEFAULT_AWS_REGION="eu-central-1"

function unset_awssso() {
    unset AWS_PROFILE
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    unset AWS_REGION
}

function awssso() {
    unset_awssso

    echo -n "AWS SSO Profile: "
    read aws_sso_profile
    export AWS_PROFILE=${aws_sso_profile}

    aws sso login --profile $AWS_PROFILE > /dev/null
    if ! [ "${?}" -eq 0 ]; then
        echo "[ERR] Failed to log in!" >&2
        return 1
    fi
    echo "[OK] Successfully logged in."  

    echo "\nReading access token..."
    SSO_ACCESS_JSON_PATH="${SSO_CACHE_PATH}/$(eval ls -tr ${SSO_CACHE_PATH} | tail -1)"
    if ! [ "${?}" -eq 0 ]; then
        echo "[ERR] Failed to retrieve access token!" >&2
        return 1
    fi
    SSO_ACCESS_TOKEN=$(eval cat $SSO_ACCESS_JSON_PATH | jq -r .accessToken)
    SSO_ACCOUNT_ID_PARAM=$(awk "/${AWS_PROFILE}/{flag=1} flag && /sso_account_id/ {print; exit}" ~/.aws/config)
    SSO_ACCOUNT_ID=$(echo $SSO_ACCOUNT_ID_PARAM | cut -d "=" -f 2 | tr -d '[:space:]')
    echo "> SSO account ID: ${SSO_ACCOUNT_ID}"
    SSO_ROLE_NAME_PARAM=$(awk "/${AWS_PROFILE}/{flag=1} flag && /sso_role_name/ {print; exit}" ~/.aws/config)
    SSO_ROLE_NAME=$(echo $SSO_ROLE_NAME_PARAM | cut -d "=" -f 2 | tr -d '[:space:]')
    echo "> SSO role name: ${SSO_ROLE_NAME}"
    SSO_REGION_PARAM=$(awk "/${AWS_PROFILE}/{flag=1} flag && /region/ {print; exit}" ~/.aws/config)
    SSO_REGION=$(echo $SSO_REGION_PARAM | cut -d "=" -f 2 | tr -d '[:space:]')
    echo "> SSO region: ${SSO_REGION}"
    echo "[OK] Access token retrieved successfully." 

    echo "\nGetting SSO role credentials..."
    SSO_ROLE_CREDS=$(aws sso get-role-credentials \
        --account-id $SSO_ACCOUNT_ID \
        --role-name $SSO_ROLE_NAME \
        --access-token $SSO_ACCESS_TOKEN \
        --region $SSO_REGION \
        --output json
    )
    if ! [ "${?}" -eq 0 ]; then
        echo "[ERR] Failed to retrieve SSO role credentials!" >&2
        return 1;
    fi;
    export AWS_ACCESS_KEY_ID=$(echo $SSO_ROLE_CREDS | jq -r .roleCredentials.accessKeyId)
    export AWS_SECRET_ACCESS_KEY=$(echo $SSO_ROLE_CREDS | jq -r .roleCredentials.secretAccessKey)
    export AWS_SESSION_TOKEN=$(echo $SSO_ROLE_CREDS | jq -r .roleCredentials.sessionToken)
    USER_ID=$(aws sts get-caller-identity | jq -r .UserId)
    echo "> User ID: ${USER_ID}"
    echo "[OK] AWS credentials retrieved successfully."

    echo -n "\nAWS region to work with [$DEFAULT_AWS_REGION]: "
    read aws_region
    export AWS_REGION=${aws_region:=$DEFAULT_AWS_REGION}
    echo "[OK] AWS region set successfully."
}
