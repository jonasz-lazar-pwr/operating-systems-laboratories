#!/bin/env bash

set -eu

# Sprawdzenie, czy podano dwa parametry
if [[ "${#}" -ne 2 ]]; then
    echo "Błąd: Skrypt wymaga podania dwóch parametrów - ścieżek do katalogów."
    exit 1
fi

# Sprawdzenie istnienia podanych katalogów
if [[ ! -d "${1}" ]] || [[ ! -d "${2}" ]]; then
    echo "Błąd: Podane katalogi nie istnieją."
    exit 1
fi

# Funkcja do tworzenia dowiązań symbolicznych
create_symlinks() {
    local source_dir="${1}"
    local target_dir="${2}"

    # Przejście przez wszystkie pliki w źródłowym katalogu
    for file in "${source_dir}"/*; do
        # Tworzenie dowiązania symbolicznego tylko dla plików regularnych
        if [[ -f "${file}" ]]; then
            # Pobranie pełnej nazwy pliku
            filename=$(basename "${file}")

            # Pobranie rozszerzenia pliku
            extension="${filename##*.}"

            # Pobranie nazwy pliku bez rozszerzenia
            filename_no_ext="${filename%.*}"

            # Zmiana na WIELKIE LITERY
            filename_uppercase=$(echo "${filename_no_ext}" | tr '[:lower:]' '[:upper:]')

            # Jeśli istnieje rozszerzenie, dodaj je do nazwy dowiązania symbolicznego
            if [[ -n "${extension}" && "${extension}" != "${filename}" ]]; then
                symlink_name="${filename_uppercase}_ln.${extension}"
            else
                # Jeśli nie ma rozszerzenia, użyj tylko nazwy pliku
                symlink_name="${filename_uppercase}_ln"
            fi

            # Sprawdzenie, czy plik docelowy nie istnieje
            if [[ ! -e "${target_dir}/${symlink_name}" ]]; then
                # Tworzenie dowiązania symbolicznego
                ln -s "$(realpath "${file}")" "${target_dir}/${symlink_name}"
            else
                echo "Plik docelowy ${target_dir}/${symlink_name} już istnieje. Pomijanie..."
            fi

        # Tworzenie dowiązania symbolicznego do katalogu
        elif [[ -d "${file}" ]]; then
            # Pobranie nazwy katalogu
            dirname=$(basename "${file}")

            # Zmiana na WIELKIE LITERY
            dirname_uppercase=$(echo "${dirname}" | tr '[:lower:]' '[:upper:]')

            # Dodanie sufiksu "_ln"
            symlink_name="${dirname_uppercase}_ln"

            # Sprawdzenie, czy plik docelowy nie istnieje
            if [[ ! -e "${target_dir}/${symlink_name}" ]]; then
                # Tworzenie dowiązania symbolicznego dla katalogów
                ln -s "$(realpath "${file}")" "${target_dir}/${symlink_name}"
            else
                echo "Plik docelowy ${target_dir}/${symlink_name} już istnieje. Pomijanie..."
            fi

        # Tworzenie dowiązania symbolicznego do dowiązania symbolicznego
        elif [[ -L "${file}" ]]; then
            # Pobranie nazwy dowiązania symbolicznego
            linkname=$(basename "${file}")

            # Pobranie nazwy pliku bez rozszerzenia
            linkname_no_ext="${linkname%.*}"

            # Pobranie rozszerzenia
            extension="${linkname##*.}"

            # Zmiana na WIELKIE LITERY
            linkname_uppercase=$(echo "${linkname_no_ext}" | tr '[:lower:]' '[:upper:]')

            # Sprawdzenie, czy istnieje rozszerzenie
            if [[ -n "${extension}" ]]; then
                # Jeżeli istnieje rozszerzenie, tworzymy nazwę docelową z rozszerzeniem
                symlink_name="${linkname_uppercase}_ln.${extension}"
            else
                # Jeżeli brak rozszerzenia, tworzymy nazwę docelową bez rozszerzenia
                symlink_name="${linkname_uppercase}_ln"
            fi

            # Sprawdzenie, czy plik docelowy nie istnieje
            if [[ ! -e "${target_dir}/${symlink_name}" ]]; then
                # Tworzenie dowiązania symbolicznego dla istniejących dowiązań symbolicznych
                ln -s "$(readlink "${file}")" "${target_dir}/${symlink_name}"
            else
                echo "Plik docelowy ${target_dir}/${symlink_name} już istnieje. Pomijanie..."
            fi
        fi
    done
}

# Wyświetlanie informacji o plikach w katalogu źródłowym
echo "Informacje o plikach w katalogu ${1}:"
for file in "${1}"/*; do
    if [[ -d "${file}" ]]; then
        if [[ -L "${file}" ]]; then
            echo "$(basename "${file}") - Dowiązanie symboliczne do katalogu"
        else 
            echo "$(basename "${file}") - Katalog"
        fi

    elif [[ -f "${file}" ]]; then
        if [[ -L "${file}" ]]; then
            echo "$(basename "${file}") - Dowiązanie symboliczne do pliku regularnego"
        else 
            echo "$(basename "${file}") - Plik regularny"
        fi
    else
        echo "$(basename "${file}") - Nieznany typ pliku"
    fi
done

# Wywołanie funkcji do tworzenia dowiązań symbolicznych
create_symlinks "${1}" "${2}"

echo "Dowiązania symboliczne zostały utworzone w katalogu ${2}."
