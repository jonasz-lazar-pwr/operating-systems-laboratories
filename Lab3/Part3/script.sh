#!/bin/env bash

# Otwarcie pliku yolo.csv
while IFS=',' read -r id first_name last_name email gender ip_address value; do
    # Sprawdzenie, czy id jest liczbą nieparzystą
    if ((id % 2 != 0)); then
        # Wypisanie osoby na standardowe wyjście błędów
        echo "$id,$first_name,$last_name,$email,$gender,$ip_address,$value" >&2
    fi
done < yolo.csv

echo "---------------------------"

# Otwarcie pliku yolo.csv
while IFS=',' read -r id first_name last_name email gender ip_address value; do
    # Sprawdzenie, czy wartość jest równa $2.99 lub $5.99 lub $9.99
    if [[ "$value" == '$2.99M' || "$value" == '$5.99M' || "$value" == '$9.99M' || \
          "$value" == '$2.99B' || "$value" == '$5.99B' || "$value" == '$9.99B' ]]; then
        # Wypisanie nazwiska i wartości na standardowe wyjście błędów
        echo "$last_name, $value" >&2
    fi
done < yolo.csv