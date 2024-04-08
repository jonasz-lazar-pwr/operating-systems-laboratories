# Part1

Ten skrypt napisany w Bashu umożliwia tworzenie dowiązań symbolicznych w oparciu o pliki znajdujące się w określonym katalogu źródłowym. Skrypt obsługuje pliki regularne, katalogi oraz istniejące dowiązania symboliczne.

## Funkcje

- Przyjmuje dwa parametry: ścieżki do katalogów.
- Wyświetla informacje o plikach z pierwszego katalogu, w tym:
  - czy jest to katalog
  - czy jest to dowiązanie symboliczne
  - czy jest to plik regularny
- Tworzy w drugim katalogu dowiązania symboliczne do każdego pliku regularnego, katalogu oraz dowiązania symbolicznego. Dodaje "_ln" przed rozszerzeniem i zmienia nazwę na pisaną wielkimi literami, np. `filename.txt` -> `FILENAME_ln.txt`.
- Obsługuje zarówno ścieżki względne, jak i bezwzględne.

## Sposób użycia

1. Uruchom skrypt `script.sh`.
2. Podaj ścieżkę do katalogu źródłowego oraz docelowego.
3. Skrypt automatycznie utworzy dowiązania symboliczne w docelowym katalogu na podstawie plików znajdujących się w katalogu źródłowym.

## Przykład użycia

```bash
./script.sh /ścieżka/do/katalogu/źródłowego /ścieżka/do/katalogu/docelowego
```

## Uwagi
- Jeśli zadane katalogi nie istnieją, program zakończy działanie z błędem.
- Jeśli nie podano parametrów, program poinformuje użytkownika i zakończy się z błędem.
- Podane ścieżki mogą być wielokrotnie zagłębione oraz mogą być podane jako ścieżki względne lub bezwzględne.


# Part2
