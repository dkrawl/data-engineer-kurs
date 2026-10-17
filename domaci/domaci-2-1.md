# Domaci Zadatak 2.1

## SQL fudbalske utakmice

1. Dodajte kolonu empty_seats (kapacitet stadiona minus
poseta) i prikažite 5 utakmica sa najviše praznih mesta.
Šta je zajedničko prvim trima?

Resenje: Zajednicko prvim trima je isti klub Oakfield Town.

```
select
    home_team,
    away_team,
    kickoff_ts,
    stadium_capacity - attendance as empty_seats
from matches_flat
order by empty_seats desc
limit 5;
```

2. Koliko različitih sudija je sudilo domaće utakmice kluba
Riverton Athletic?

Resenje: 15.

```
select
    count(*) as referees
from (
    select distinct
        referee_name
    from matches_flat
    where home_team = 'Riverton Athletic'
) as r;
```

3. U koliko utakmica je gost vodio na poluvremenu, a
domaćin na kraju pobedio?

Resenje: 15.

```
select
    count(*) as matches
from (
    select
        match_id
    from matches_flat
    where home_goals_ht < away_goals_ht
    and home_goals > away_goals
) as m;
```

4. U kojoj utakmici je palo najviše golova u drugom
poluvremenu? Ko je igrao, rezultat na poluvremenu i
rezultat na kraju?

Resenje:
    igrali: Northport United i Newbury Forest
    rezultat na poluvremenu: 1-0
    rezultat na kraju: 6-3
    broj golova u drugom poluvremenu: 8

```
select
    home_team,
    away_team,
    concat(home_goals_ht, '-', away_goals_ht) as half_time,
    concat (home_goals, '-', away_goals) as full_time,
    (home_goals - home_goals_ht) + (away_goals - away_goals_ht) as second_half_goals
from matches_flat
order by second_half_goals desc
limit 1;
```

5. Koliko utakmica sezone 2023/24 je odigrano po snegu
ili magli?

6. Prikažite sve utakmice gradskog derbija između
Northport United i Northport City, bez obzira na to ko je
domaćin, sortirane po datumu. Ko je pobedio u kom
meču?

7. Prikažite prve 3 utakmice sezone 2024/25 po vremenu
početka. Da li možete biti sigurni koja je druga, a koja
treća? Kako biste to obezbedili?

8. Prikažite sve utakmice u kojima je prvi gol dao Sean
O'Neill. Koliko ih je?
