#!/bin/bash -eu

function print_help () {
    echo "This script allows to search over movies database"
    echo -e "-d DIRECTORY\n\tDirectory with files describing movies"
    echo -e "-a ACTOR\n\tSearch movies that this ACTOR played in"
    echo -e "-t QUERY\n\tSearch movies with given QUERY in title"
    echo -e "-f FILENAME\n\tSaves results to file (default: results.txt)"
    echo -e "-x\n\tPrints results in XML format"
    echo -e "-h\n\tPrints this help message"
}

function print_error () {
    # echo -e "\e[31m\033[1m${@}\033[0m" >&2 - Błąd 1
    echo -e "\e[31m\033[1m${*}\033[0m" >&2
}

function get_movies_list () {
    local -r MOVIES_DIR=${1}
    local -r MOVIES_LIST=$(cd "${MOVIES_DIR}" && realpath ./*)
    echo "${MOVIES_LIST}"
}

function query_title () {
    # Returns list of movies from ${1} with ${2} in title slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        # if grep "| Title" ${MOVIE_FILE} | grep -q "${QUERY}"; then - Błąd 2
        if grep "| Title" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
            # RESULTS_LIST+=( ${MOVIE_FILE} ) - Błąd 3
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function query_actor () {
    # Returns list of movies from ${1} with ${2} in actor slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Actors" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
            # RESULTS_LIST+=( ${MOVIE_FILE} ) - Błąd 4
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function print_movies () {
    local -r MOVIES_LIST=${1}
    local -r OUTPUT_FORMAT=${2}

    for MOVIE_FILE in ${MOVIES_LIST}; do
        if [[ "${OUTPUT_FORMAT}" == "xml" ]]; then
            print_xml_format "${MOVIE_FILE}"
        else
            cat "${MOVIE_FILE}"
        fi
    done
}


# function print_xml_format () {
#     local -r FILENAME=${1}

#     local TEMP
#     TEMP=$(cat "${FILENAME}")

#     # Add <movie> tag at the beginning
#     echo "<movie>"

#     # Zamiana 'Author:' na <Author>
#     TEMP=$(echo "${TEMP}" | sed 's/Author:/<Author>/')

#     # Zamiana 'Title:' na <Title>
#     TEMP=$(echo "${TEMP}" | sed 's/Title:/<Title>/')

#     # Zamiana 'Year:' na <Year>
#     TEMP=$(echo "${TEMP}" | sed 's/Year:/<Year>/')

#     # Zamiana 'Runtime:' na <Runtime>
#     TEMP=$(echo "${TEMP}" | sed 's/Runtime:/<Runtime>/')

#     # Zamiana 'IMDB:' na <IMDB>
#     TEMP=$(echo "${TEMP}" | sed 's/IMDB:/<IMDB>/')

#     # Zamiana 'Tomato:' na <Tomato>
#     TEMP=$(echo "${TEMP}" | sed 's/Tomato:/<Tomato>/')

#     # Zamiana 'Rated:' na <Rated>
#     TEMP=$(echo "${TEMP}" | sed 's/Rated:/<Rated>/')

#     # Zamiana 'Genre:' na <Genre>
#     TEMP=$(echo "${TEMP}" | sed 's/Genre:/<Genre>/')

#     # Zamiana 'Director:' na <Director>
#     TEMP=$(echo "${TEMP}" | sed 's/Director:/<Director>/')

#     # Zamiana 'Actors:' na <Actors>
#     TEMP=$(echo "${TEMP}" | sed 's/Actors:/<Actors>/')

#     # Zamiana 'Plot:' na <Plot>
#     TEMP=$(echo "${TEMP}" | sed 's/Plot:/<Plot>/')

#     # append closing tag after each line
#     TEMP=$(echo "${TEMP}" | sed -r 's/([A-Za-z]+):(.*)/<\1>\2<\/\1>/')

#     echo "${TEMP}"

#     # Add closing </movie> tag at the end
#     echo "</movie>"
# }

function print_xml_format () {
    local -r FILENAME=${1}

    local TEMP
    TEMP=$(cat "${FILENAME}")

    # Zamiana pierwszej linii znaków równości na tag <movie>
    TEMP=$(echo "${TEMP}" | sed '1 s/^=/<movie>/')

    # Zamiana 'Author:' na <Author>
    TEMP=$(echo "${TEMP}" | sed 's/Author:/<Author>/')

    # Zamiana 'Title:' na <Title>
    TEMP=$(echo "${TEMP}" | sed 's/Title:/<Title>/')

    # append tag after each line
    TEMP=$(echo "${TEMP}" | sed -r 's/([A-Za-z]+).*/\0<\/\1>/')

    # replace the last line with </movie>
    TEMP=$(echo "${TEMP}" | sed '$s/===*/<\/movie>/')

    echo "${TEMP}"
}


# Walidacja czy podano ścieżkę do katalogu
function validate_directory () {
    local DIR=${1}
    if [[ ! -d "${DIR}" ]]; then
        print_error "ERROR: ${DIR} is not a directory."
        exit 1
    fi
}

# Flaga informująca, czy opcja -d została podana
dir_flag=false

while getopts ":hd:t:a:f:x" OPT; do
    case ${OPT} in
        h)
            print_help
            exit 0
            ;;
        d)
            MOVIES_DIR=${OPTARG}
            validate_directory "${MOVIES_DIR}"  # Walidacja ścieżki tuż po jej ustawieniu
            dir_flag=true  # Ustawienie flagi na true, gdy opcja -d zostanie podana
            ;;
        t)
            SEARCHING_TITLE=true
            QUERY_TITLE=${OPTARG}
            ;;
        f)
            FILE_4_SAVING_RESULTS=${OPTARG}
            ;;
        a)
            SEARCHING_ACTOR=true
            QUERY_ACTOR=${OPTARG}
            ;;
        x)
            OUTPUT_FORMAT="xml"
            ;;
        \?)
            print_error "ERROR: Invalid option: -${OPTARG}"
            exit 1
            ;;
    esac
done

# Jeśli flaga -d nie jest ustawiona na true, wyświetl komunikat o błędzie
if ! ${dir_flag}; then
    print_error "ERROR: Directory option (-d) is required."
    exit 1
fi

# Jeśli użytkownik nie podał nazwy pliku, ustaw domyślną na "results.txt"
if [[ -z "${FILE_4_SAVING_RESULTS:-}" ]]; then
    FILE_4_SAVING_RESULTS="results.txt"
fi

MOVIES_LIST=$(get_movies_list "${MOVIES_DIR}")

if ${SEARCHING_TITLE:-false}; then
    # MOVIES_LIST=`query_title "${MOVIES_LIST}" "${QUERY_TITLE}"` - Błąd 6
    MOVIES_LIST=$(query_title "${MOVIES_LIST}" "${QUERY_TITLE}")
fi

if ${SEARCHING_ACTOR:-false}; then
    MOVIES_LIST=$(query_actor "${MOVIES_LIST}" "${QUERY_ACTOR}")
fi

# if [[ "${#MOVIES_LIST}" < 1 ]]; then - Błąd 7
if [[ "${#MOVIES_LIST}" -lt 1 ]]; then
    echo "Found 0 movies :-("
    exit 0
fi

if [[ "${FILE_4_SAVING_RESULTS:-}" == "" ]]; then
    print_movies "${MOVIES_LIST}" "${OUTPUT_FORMAT:-raw}" >> results.xml
else
    print_movies "${MOVIES_LIST}" "${OUTPUT_FORMAT:-raw}" | tee "${FILE_4_SAVING_RESULTS}" >> results.xml
fi
