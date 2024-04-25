#!/bin/env bash

./fakaping.sh > /dev/null | sort

./fakaping.sh 2>&1 | grep -i "permission denied" | sort -u | tee denied.log >&2
