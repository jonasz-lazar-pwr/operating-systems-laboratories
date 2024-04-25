#!/bin/env bash

grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]" access_log.txt | sort -u | head -n 10

grep -E "\"DELETE \/" access_log.txt | sort -u
