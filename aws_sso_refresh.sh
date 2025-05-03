#!/bin/bash

function awsssologin() {
    local envexport="$1" isretry="$2"
    local cache expires login=false
    local awsbin=/usr/bin/aws

    if [[ -d "$HOME/.aws/sso/cache" ]]; then
        for cache in "$HOME"/.aws/sso/cache/*.json; do
            if ! grep -q "startUrl" "$cache" || ! grep -q "expiresAt" "$cache"; then
                continue
            fi

            expires="$(date -d "$(jq -r '.expiresAt' < "$cache")" +%s)"
            if [[ "$expires" -ge "$(date +%s)" ]];then
                login=true
            fi
        done
    fi

    if [[ "$login" == "false" ]];then
        $awsbin sso login 1>&2
    fi

    # optionally export credentials
    if [[ "$envexport" != "" && -z "$AWS_ACCESS_KEY_ID" ]]; then
        local credfile=""
        if [[ -d "$HOME/.aws/cli/cache"  ]]; then
            for cache in "$HOME"/.aws/cli/cache/*.json; do
               if ! grep -q '"ProviderType": "sso"' "$cache" || ! grep -q "Expiration" "$cache" || ! grep -q "AccessKeyId" "$cache"; then
                    continue
               fi
                expires="$(date -d "$(jq -r '.Credentials.Expiration' < "$cache")" +%s)"
                if [[ "$expires" -ge "$(date +%s)" ]];then
                    credfile="$cache"
                fi
            done
        fi
        if [[ -n "$credfile" ]]; then
            export AWS_ACCESS_KEY_ID=$(jq '.Credentials.AccessKeyId' --raw-output < "$credfile")
            export AWS_SECRET_ACCESS_KEY=$(jq '.Credentials.SecretAccessKey' --raw-output < "$credfile")
            export AWS_SESSION_TOKEN=$(jq '.Credentials.SessionToken' --raw-output < "$credfile")
        else
            # no credentials issued yet, retry triggers aws call
            if [[ "$isretry" == "" ]]; then
                $awsbin sts get-caller-identity > /dev/null
                awsssologin "export" "retry"
            fi
        fi
    fi
}

## in bashrc
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# either run it explicitly
awssologin # "exportenv" is optional
# or put it into a wrapper bin script to automate sso ween calling the cli
# awsssologin # "exportenv" is optional
# exec /usr/bin/aws "$@"
