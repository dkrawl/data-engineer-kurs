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
    count(distinct referee_name) as referees
from matches_flat
where home_team = 'Riverton Athletic';
```

3. U koliko utakmica je gost vodio na poluvremenu, a
domaćin na kraju pobedio?

Resenje: 15.

```
select
    count(*) as matches
from matches_flat
where home_goals_ht < away_goals_ht
and home_goals > away_goals;
```

4. U kojoj utakmici je palo najviše golova u drugom
poluvremenu? Ko je igrao, rezultat na poluvremenu i
rezultat na kraju?

Resenje:
- igrali: Northport United i Newbury Forest
- rezultat na poluvremenu: 1-0
- rezultat na kraju: 6-3
- broj golova u drugom poluvremenu: 8

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

Resenje: 25

```
select
    count(*) as matches
from matches_flat
where season = '2023/24'
and weather in ('snow', 'fog');
```

6. Prikažite sve utakmice gradskog derbija između
Northport United i Northport City, bez obzira na to ko je
domaćin, sortirane po datumu. Ko je pobedio u kom
meču?

Resenje:
- mec: Northport City - Northport United, datum 2023-11-11, FT 0-1: pobedio Northport United u gostima
- mec: Northport City - Northport United, datum 2024-09-21, FT 3-1: pobedio Northport City kod kuce
- mec: Northport United - Northport City, datum 2025-02-01, FT 2-1: pobedio Northport United kod kuce

```
select
    home_team,
    away_team,
    date(kickoff_ts) as match_date,
    concat(home_goals, '-', away_goals) as full_time
from matches_flat
where (home_team = 'Northport United' and away_team = 'Northport City')
or (home_team = 'Northport City' and away_team = 'Northport United')
order by match_date asc;
```

7. Prikažite prve 3 utakmice sezone 2024/25 po vremenu
početka. Da li možete biti sigurni koja je druga, a koja
treća? Kako biste to obezbedili?

Resenje: Ne mozemo biti sigurni koja je druga, a koja treca jer imaju isti kickof_ts.
SQL ne garantuje redosled redova koji imaju istu vrednost kolone po kojoj se sortiraju.
Da bismo utvrdili stvarni redosled po vremenu pocetka, potreban nam je dodatni, precizniji vremenski podatak.

```
select
    home_team,
    away_team,
    season,
    kickoff_ts,
    date(kickoff_ts) as match_date,
    time(kickoff_ts) as match_time
from matches_flat
where season = '2024/25'
order by kickoff_ts asc;
```

8. Prikažite sve utakmice u kojima je prvi gol dao Sean
O'Neill. Koliko ih je?

Resenje: 2.

```
select
    home_team,
    away_team,
    date(kickoff_ts) as match_date,
    first_goal_scorer
from matches_flat
where first_goal_scorer = 'Sean O\'Neill';
```
