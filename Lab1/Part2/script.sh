#!/bin/env bash

# Pobranie argumentów o wartościach domyślnych
SOURCE_DIR="${1:-lab_uno}"
RM_LIST="${2:-2remove}"
TARGET_DIR="${3:-bakap}"

# Sprawdzenie, czy TARGET_DIR istnieje
# -d zwraca wartość true, jeśli folder istnieje
if [[ ! -d "${TARGET_DIR}" ]]; then
    echo "Utworzenie katalogu: ${TARGET_DIR}"
    mkdir "${TARGET_DIR}"
fi

# Zmiana katalogu na SOURCE_DIR
cd "${SOURCE_DIR}"

# Iteracja po zawartości pliku RM_LIST
# "IFS=" - separator wierszy ustawiony na puste
# "read" - czytamy linię z wejścia
while IFS= read element; do

    # Sprawdzenie, czy plik istnieje w SOURCE_DIR
    # -e zwraca wartość true, jeśli cel (plik, katalog) istnieje
    if [[ -e "${element}" ]]; then
        echo "Usuwanie: ${element}"
        rm -rf "${element}"
    else
        echo "${element} nie istnieje w ${SOURCE_DIR}"
    fi
done < "../${RM_LIST}"

# Iteracja po zawartości katalogu SOURCE_DIR
for element in *; do

    # Sprawdzenie, czy plik lub katalog nie istnieje na liście RM_LIST
    if ! grep -qx "${element}" "../${RM_LIST}"; then

        # Sprawdzenie, czy element jest katalogiem
        if [[ -d "${element}" ]]; then
            echo "Kopiowanie katalogu: ${element} do ${TARGET_DIR}"
            cp -r "${element}" "../${TARGET_DIR}"

        # Sprawdzenie, czy element jest plikiem
        elif [[ -f "${element}" ]]; then
            echo "Przenoszenie pliku: ${element} do ${TARGET_DIR}"
            mv "${element}" "../${TARGET_DIR}"
        fi
    fi
done

# Sprawdzenie, czy pozostały jakieś pliki w katalogu SOURCE_DIR

# Komentarz: Używamy polecenia ls wraz z przekierowaniem 
# jego wyniku do polecenia wc -l. Polecenie ls listuje pliki 
# w bieżącym katalogu, a wc -l zlicza ilość linii, co w tym 
# przypadku odpowiada liczbie plików

remaining_files=$(ls | wc -l)

# -ge: większy lub równy
# -gt: większy niż
if [[ "${remaining_files}" -gt 0 ]]; then
    echo "Jeszcze coś zostało"

    if [[ "${remaining_files}" -ge 2 ]]; then
        echo "Zostały co najmniej 2 pliki"
    fi

    if [[ "${remaining_files}" -gt 4 ]]; then
        echo "Zostało więcej niż 4 pliki"
    elif [[ "${remaining_files}" -gt 2 ]]; then
        echo "Zostało co najmniej 2, ale nie więcej niż 4 pliki"
    fi
else
    echo "Nic nie zostało"
fi

cd "../"

# Utworzenie archiwum zip z katalogu TARGET_DIR
current_date=$(date +"%Y-%m-%d")
zip -r "bakap_${current_date}.zip" "${TARGET_DIR}"
