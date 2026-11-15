# Рад са фајловима и CSV
#
#      Фајлове увек отварати помоћу with
#      За CSV фајлове користити модул csv
#      Функције су задате у истом формату као на прошлом часу: func_name(var1: type, var2: type)
#      -> type

# Фајл data/raw/teams.csv:
#
#       team,city,points
#       FK Jedinstvo,Bela Palanka,34
#       FK Radnički,Niš,41
#       FK Rakovica,"Beograd, Rakovica",28
#       FK Sloga,Kraljevo,19


# Imports and paths
import csv
teams = 'data/raw/teams.csv'
summary = 'data/processed/summary.csv'

# Задаци са фајловима

# 16. Написати функцију count_lines(path: str) -> int која враћа број непразних редова у фајлу
#
#         Input: 'data/raw/teams.csv'
#         Output: 5


def count_lines(path: str) -> int:
    count = 0
    with open(path, 'r') as f:
        reader = list(csv.reader(f))

        for row in reader:
            if len(row) == 0:
                continue
            count += 1
    return count

count_lines(teams)
# returns 5

# 17. Написати функцију read_column(path: str, column: str) -> list која враћа све вредности
# једне колоне CSV фајла
#
#         Input: 'data/raw/teams.csv', 'city'
#         Output: ['Bela Palanka', 'Niš', 'Beograd, Rakovica', 'Kraljevo']
#         Ако колона не постоји, вратити празну листу []

def read_column(path: str, column: str) -> list:
    with open(path, 'r') as f:
        reader = csv.DictReader(f)

        if column not in reader.fieldnames:
            return []
        return [row[column] for row in reader]

print(read_column(teams, 'city'))
# returns: ['Bela Palanka', 'Niš', 'Beograd, Rakovica', 'Kraljevo']


# 18. Написати функцију write_key_value(path: str, data: dict, headers: list) -> None која
# речник уписује у CSV фајл са две колоне
#
#         Input: 'data/processed/summary.csv', {'rows': 10, 'valid': 6}, ['metric', 'value']
#         Садржај фајла након позива:
#
#            metric,value
#            rows,10
#            valid,6


def write_key_value(path: str, data: dict, headers: list) -> None:
    with open(path, 'w') as f:
        writer = csv.DictWriter(f, fieldnames=headers)
        writer.writeheader()
        writer.writerows([{'metric': k, 'value': v} for k, v in data.items()])

write_key_value(summary, {'rows': 10, 'valid': 6}, ['metric', 'value'])

# Задаци са csv модулом

# 19. Написати функцију get_header(path: str) -> list која враћа заглавље CSV фајла
#
#         Користити csv.reader и next()
#         Input: 'data/raw/teams.csv'
#         Output: ['team', 'city', 'points']

def get_header(path: str) -> list:
    with open(path, 'r') as f:
        header = next(csv.reader(f))
        return header

get_header(teams)
# returns ['team', 'city', 'points']

# 20. Написати функцију read_rows(path: str) -> list која враћа све редове CSV фајла без
# заглавља, као листу листи
#
#         Користити csv.reader
#         Input: 'data/raw/teams.csv'
#         Output: [['FK Jedinstvo', 'Bela Palanka', '34'], ['FK Radnički', 'Niš', '41'],
#         ['FK Rakovica', 'Beograd, Rakovica', '28'], ['FK Sloga', 'Kraljevo', '19']]

def read_rows(path: str) -> list:
    with open(path, 'r') as f:
        reader = csv.reader(f)
        header = next(reader)
        return [t for t in reader]

print(read_rows(teams))
# returns [['FK Jedinstvo', 'Bela Palanka', '34'], ['FK Radnički', 'Niš', '41'], ['FK Rakovica', 'Beograd, Rakovica', '28'], ['FK Sloga', 'Kraljevo', '19']]


# 21. Написати функцију total_points(path: str) -> int која враћа збир бодова свих тимова
#         Користити csv.DictReader
#         Input: 'data/raw/teams.csv'
#         Output: 122

def total_points(path: str) -> int:
    total_pts = 0

    with open(path) as f:
        reader = list(csv.DictReader(f))

        for row in reader:
            total_pts += int(row['points'])

    return total_pts

total_points(teams)
# returns 122

# 22. Написати функцију write_rows(path: str, rows: list) -> None која листу листи уписује у CSV
# фајл
#
#         Input: 'data/processed/people.csv', [['name', 'age'], ['Ana', 20], ['Marko', 22]]
#         Садржај фајла након позива:
#
#            name,age
#            Ana,20
#            Marko,22

def write_rows(path: str, rows: list) -> None:
    with open(path, 'w') as f:
        writer = csv.writer(f)
        writer.writerows(rows)

write_rows('data/processed/people.csv', [['name', 'age'], ['Ana', 20], ['Marko', 22]])
# writes csv file:
#            name,age
#            Ana,20
#            Marko,22


# 23. Написати функцију write_dicts(path: str, rows: list) -> None која листу речника уписује у
#      CSV фајл
#
#         Користити csv.DictWriter; заглавља су кључеви првог речника
#         Input: 'data/processed/people.csv', [{'name': 'Ana', 'age': 20}, {'name':
#         'Marko', 'age': 22}]
#         Садржај фајла након позива:
#
#            name,age
#            Ana,20
#            Marko,22

def write_dicts(path: str, rows: list) -> None:
    with open(path, 'w') as f:
        fieldnames = rows[0].keys()
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)

write_dicts('data/processed/people.csv', [{'name': 'Ana', 'age': 20}, {'name':'Marko', 'age': 22}])
# writes csv file:
#            name,age
#            Ana,20
#            Marko,22
