function aws-mfa() {
  if [ "x$_AWS_ACCESS_KEY_ID" != "x" ]; then
    clear-aws-mfa
  fi

  echo -n "MFA token code: "
  read code

  credentials=$(aws sts get-session-token --serial-number "$(aws iam list-mfa-devices | jq -r '.MFADevices[0].SerialNumber')" --token-code "$code")

  export _AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
  export _AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

  export AWS_ACCESS_KEY_ID=$(echo "$credentials" | jq -r '.Credentials.AccessKeyId')
  export AWS_SECRET_ACCESS_KEY=$(echo "$credentials" | jq -r '.Credentials.SecretAccessKey')
  export AWS_SESSION_TOKEN=$(echo "$credentials" | jq -r '.Credentials.SessionToken')
}

function clear-aws-mfa() {
  export AWS_ACCESS_KEY_ID=$_AWS_ACCESS_KEY_ID
  export AWS_SECRET_ACCESS_KEY=$_AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN _AWS_ACCESS_KEY_ID _AWS_SECRET_ACCESS_KEY
}
