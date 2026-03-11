import random

def main():
    field = [[' ' for _ in range(3)] for _ in range(3)]
    print_playboard(field)

    game_mode = input('game with computer press t if not press any key ')
    computer = True if game_mode.lower() == 't' else False
    player = 'X'
    moves_left = 9
    end_game = False

    while not end_game:
        print_playboard(field)
        print('Enter your move,player', player, ':')
        
        if not computer or player == 'X':
            try:
                row = int(input('row: '))
                column = int(input('column: '))
                move(row, column, player, field)
                moves_left -= 1
            except (ValueError, TypeError):
                print('incorrect move')
                continue
        else:
            selected_row=random.choice([i for i in range(3)])
            selected_column=random.choice([j for j in range(3)])
            if field[selected_row][selected_column]==' ':
                move(selected_row,selected_column,'O',field )                
            moves_left -=1


        winner = check_if_game_end(field)
        if winner:
            print_playboard(field)
            print('Winner', winner)
            end_game = True
        elif moves_left == 0:
            print_playboard(field)
            print('draw')
            end_game = True

        player = 'O' if player == 'X' else 'X'


def print_playboard(field):
    print('-------')
    for row in field:
        print('|', end='')
        for cell in row:
            print(cell, end='')
            print('|', end='')
        print()
        print('-------')


def move(row, col, sign, field):
    if row > 2 or col > 2:
        raise ValueError
    elif sign not in ['X', 'O']:
        raise ValueError
    elif field[row][col] != ' ':
        raise ValueError
    else:
        field[row][col] = sign


def check_if_game_end(field):
    for row in field:
        if row[0] != ' ' and all(cell == row[0] for cell in row):
            return row[0]

    for col in range(3):
        if field[0][col] != ' ' and all(field[row][col] == field[0][col] for row in range(3)):
            return field[0][col]
    if field[0][0] != ' ' and field[0][0] == field[1][1] == field[2][2]:
        return field[0][0]
    if field[0][2] != ' ' and field[0][2] == field[1][1] == field[2][0]:
        return field[0][2]
    if all(cell != ' ' for row in field for cell in row):
        return "draw"


if __name__ == '__main__':
    main()
