# Part2

### Wstęp
Ten skrypt Bashowy ma za zadanie obsługiwać operacje na plikach zgodnie z podanymi instrukcjami. Poniżej przedstawiono szczegóły działania skryptu:

1. Krok - Pobranie Argumentów
Skrypt przyjmuje 3 argumenty: `SOURCE_DIR`, `RM_LIST`, `TARGET_DIR`. Wartości domyślne dla tych argumentów to odpowiednio: `lab_uno`, `2remove`, `bakap`.
Do wygenerowania losowych plików i katalogów wykorzystano skrypt kanai_cube_modified.sh (wprowadzono w nim małą modyfikację)

2. Krok - Tworzenie Katalogu TARGET_DIR
Jeśli katalog `TARGET_DIR` nie istnieje, skrypt automatycznie go tworzy.

3. Krok - Usuwanie Plików zgodnie z Listą
Skrypt iteruje się po zawartości pliku `RM_LIST` i usuwa tylko te pliki, które istnieją w katalogu `SOURCE_DIR`.

4. Krok - Przenoszenie lub Kopiowanie Plików
Jeżeli dany plik nie znajduje się na liście, ale jest plikiem regularnym, to jest przenoszony do katalogu `TARGET_DIR`. Jeżeli jest katalogiem, to jest kopiowany wraz z zawartością.

5. Krok - Sprawdzenie Pozostałych Plików
Po zakończeniu operacji skrypt sprawdza, czy w katalogu `SOURCE_DIR` pozostały jakiekolwiek pliki. W zależności od liczby pozostałych plików, wyświetla odpowiednie komunikaty.

6. Krok - Pakowanie Katalogu TARGET_DIR
Na koniec skrypt pakuje katalog `TARGET_DIR` do archiwum ZIP i nadaje mu nazwę `bakap_DATA.zip`, gdzie `DATA` to dzień uruchomienia skryptu w formacie RRRR-MM-DD.
