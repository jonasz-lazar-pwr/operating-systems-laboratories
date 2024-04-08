#!/bin/env bash

# Ustawienie flagi -eu
set -eu

# Sprawdzenie czy podano parametr
if [[ "${#}" -eq 0 ]]; then
    echo "Nie podano ścieżki jako parametru."
    exit 1
fi

# Pobranie ścieżki katalogu
directory=$(realpath "$1")

# Sprawdzenie czy podana ścieżka istnieje i jest katalogiem
if [[ ! -d "${directory}" ]]; then
    echo "Podana ścieżka nie istnieje lub nie jest katalogiem: ${directory}"
    exit 1
fi

# Funkcja do ustawiania uprawnień dla katalogów
set_permissions_dir() {
    local path="${1}"
    local extension="${2}"

    # Ustawienie uprawnień dla .bak
    if [[ "${extension}" = "bak" ]]; then
        chmod o+x "${path}"  # Pozwala innym wchodzić do środka tylko w katalogu z rozszerzeniem .bak
        chmod o-rwx "${path}"  # Odbieranie uprawnień do edytowania dla innych w katalogu .bak
    fi

    # Ustawienie uprawnień dla .tmp
    if [[ "${extension}" = "tmp" ]]; then
        chmod o+wx "${path}"  # Pozwala każdemu tworzyć i usuwać tylko jego pliki w katalogu .tmp
    fi
}

# Funkcja do ustawiania uprawnień dla plików
set_permissions_file() {
    local path="${1}"
    local extension="${2}"

    # Ustawienie uprawnień dla .bak
    if [[ "${extension}" = "bak" ]]; then
        chmod u-w "${path}"  # Odbieranie uprawnień do edytowania właścicielowi
        chmod o-w "${path}"  # Odbieranie uprawnień do edytowania innym
    fi

    # Ustawienie uprawnień dla .txt
    if [[ "${extension}" = "txt" ]]; then
        chmod u=r,g=w,o=x "${path}"  # Właściciele czytają, grupa edytuje, inni mogą wykonywać
    fi

    # Ustawienie uprawnień dla .exe
    if [[ "${extension}" = "exe" ]]; then
        chmod u+x "${path}"  # Wykonywalne dla właściciela
    fi
}

# Przetwarzanie plików i katalogów
process_directory() {
    local dir="${1}"

    # Pętla po elementach w katalogu
    for item in "${dir}"/*; do
        if [[ -d "${item}" ]]; then
            # Pobranie nazwy katalogu
            dirname=$(basename "${item}")

            # Pobranie rozszerzenia
            extension="${dirname##*.}"
            
            set_permissions_dir "${item}" "${extension}"

            # Rekurencyjne przetwarzanie podkatalogów
            process_directory "${item}"
        elif [[ -f "${item}" ]]; then
            # Pobranie nazwy pliku
            filename=$(basename "${item}")

            # Pobranie rozszerzenia
            extension="${filename##*.}"

            set_permissions_file "${item}" "${extension}"
        fi
    done
}

# Uruchomienie funkcji dla podanego katalogu
process_directory "${directory}"
