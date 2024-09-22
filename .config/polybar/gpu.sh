#!/bin/bash

json=$(gpustat --json 2>/dev/null)
if [[ $json ]]
then
	echo "$(echo "$json" | jq '.gpus[0]."utilization.gpu"')% ($(echo "$json" | jq '.gpus[0]."temperature.gpu"')°C)"
else
	echo "No GPU found"
fi
