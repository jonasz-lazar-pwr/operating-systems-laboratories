# Tic Tac Toe

Napisz prostą grę typu Tic Tac Toe.

## Zadania

### Osoba A
- Odpowiada za wyświetlenie planszy.
- Sprawdza, czy gra się zakończyła.
- Definiuje planszę.

### Osoba B
- Odpowiada za decyzję komputera.
- Pobiera i waliduje decyzje użytkownika.
- Definiuje funkcję, która decyduje, kto startuje grę (np. pyta użytkownika, czy chce zacząć, lub pyta Orzeł/Reszka i mamy rzut monetą).

### Wspólne Zadania
- `players_move` to boolean.
- Wybrana osoba pisze funkcję `announce_outcome`, która informuje, jak zakończyła się gra.
- Każdy wrzuca TYLKO swoją część (+ `main.py`) do swojego repozytorium i linkuje repozytorium partnera.

## Struktura `main.py`
```python
from studentA import print_board, is_game_over, new_board
from studentB import ai_move, get_user_move, is_player_starting, announce_outcome

board = new_board()
players_move = is_player_starting()

while not is_game_over(board):
    print_board(board)
    board = players_move and get_user_move(board) or ai_move(board)
    players_move = not players_move

announce_outcome(board, players_move)
```

## Dodatkowe Informacje

### Wymagana Ocena
- Grupa zaczyna od oceny 3.0.
- Waszym wspólnym interfejsem jest obiekt planszy.

### Dodatkowe Punkty
- +1.0 Funkcja, która sprawdza, czy gra powinna się zakończyć i funkcja `announce_outcome`.
- +1.0 Pobieranie i używanie decyzji użytkownika.
- +1.0 Generowanie ruchu komputera.
- +1.0 Wypisywanie planszy.
- +1.0 Jeżeli komputer będzie próbował blokować człowieka.
- +1.0 Plansza jest 5x5, zamiast 3x3 (można od razu tworzyć grę 5x5).
- +1.0 Użytkownik ma tylko 5 sekund na decyzję.

### Wymagania na Wyższą Ocenę
- Należy wykonać wcześniejsze zadania.
- Kod musi być zgodny z PEP8.
- Obie osoby muszą rozumieć, co się dzieje w całym kodzie.
- Na szczególną ocenę zasługują czytelność kodu i wydajność.

Link do Repozytorium studenta B:  
[GitHub - SzymonSergiusz/so2-zadania/tree/main/lab5-tictac](https://github.com/SzymonSergiusz/so2-zadania/tree/main/lab5-tictac)
