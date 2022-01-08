#!/bin/bash

if [[ "$1" == "bash" ]]; then
    bash --init-file <(echo "ls; pwd")
    exit 0
else
    echo "run waf and pass through command '$@'"
    ./waf --run "$@"
    exit $?
fi

