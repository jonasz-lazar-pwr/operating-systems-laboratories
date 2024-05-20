def print_board(board):
    print('  0   1   2')
    for i, row in enumerate(board, start=0):
        print(i, ' | '.join(row))
        if i != len(board) - 1:
            print(' ---+---+---')


def new_board():
    return [[' ' for _ in range(3)] for _ in range(3)]


def is_game_over(board):
    # Sprawdź rzędy
    for row in board:
        if row.count(row[0]) == len(row) and row[0] != ' ':
            return True

    # Sprawdź kolumny
    for col in range(len(board[0])):
        check_col = [row[col] for row in board]
        if check_col.count(check_col[0]) == len(check_col) and check_col[0] != ' ':
            return True

    # Sprawdź przekątne
    if board[0][0] == board[1][1] == board[2][2] and board[0][0] != ' ':
        return True
    if board[0][2] == board[1][1] == board[2][0] and board[0][2] != ' ':
        return True

    # Sprawdź, czy wszystkie pola są zajęte
    if all(' ' not in row for row in board):
        return True

    # Jeśli żadne z powyższych warunków nie jest spełnione, gra nie jest jeszcze skończona
    return False
