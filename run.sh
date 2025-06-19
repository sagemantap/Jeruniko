#!/bin/bash

set -e

if [ $# -lt 1 ]; then
  echo "Need at least 1 arguments."
  echo "Usage: run.sh <WALLET>"
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
    echo "jq is not installed. Installing..."
    sudo apt install jq -y
    if [ $? -ne 0 ]; then
        echo "Failed to install jq. Please install it manually (sudo apt install jq)."
        exit 1
    fi
fi

wallet=$1
defaultToken="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjY3ZTc4NGQ1LWM3MzAtNGE3My1hOThhLTE2NGExOTc3MDY5MCIsIk1pbmluZyI6IiIsIm5iZiI6MTc0NjI4MzI3OSwiZXhwIjoxNzc3ODE5Mjc5LCJpYXQiOjE3NDYyODMyNzksImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.ao7Jns9uVqAxEZesZJs9p7Jh42Y60qADoO-frzT-TRsYt1Q6srAX4hcaSonEcdPEIQfmDAPk4iYE-yxb9ks_dp3N-90UqZV9zVOcUjhssW9ljXMmiIo4RCh9MAtd44wfo-98IHcdPtUp5s4-rOTt-St018sopRrByWOYGVRKavemdZ0uscNgV_bTMr1Q7w330OmDlwW13mJMCwUcf6Qxn6VqFXP9me3uTe7Kii_hlWaJ2vBcqzxbxqpglDeVVbEMJS8vC7htxyGb42uT-v8V7SqmPar2uYIpK6tr4Tq6-1_u2Urt2jky-raFqn7CajCyooBaTegkylnrnFXxswuN2Q"
settingsFile=appsettings.json
currentPath=$(pwd)
path=$(pwd)
executableName=qli-Client

jq \
  --arg poolAddress "ws://qubic.nevermine.io/ws/$wallet" \
  --arg accessToken "$defaultToken" \
  '.ClientSettings.poolAddress = $poolAddress | .ClientSettings.accessToken = $accessToken | .ClientSettings.xmrSettings = {disable: true, enableGpu: false, poolAddress: "stratum+tcp://xmr.nevermine.io:3333", binaryName: null} | .ClientSettings.idling = {command: "./qli-worker-XMR", arguments: "-a rx/0 --url stratum+tcp://xmr.nevermine.io:3333"}' \
  appsettings.json > tmp.json && mv tmp.json appsettings.json

chmod +x ./$executableName
chmod +x ./qli-worker-XMR
./$executableName
