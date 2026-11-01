# Domaci Zadatak 6.1

1. Kreiranje dimenzije igrača

Na osnovu tabele players napravite tabelu dim_player koja
sadrži sledeće kolone: player_id, ime, prezime, poziciju i
nacionalnost igrača.
Koliko redova ima novokreirana tabela?

Resenje: Novokreirana tabela ima 681 igraca.

```
create or replace table dim_player as
select
    player_id,
    first_name,
    last_name,
    position,
    nationality
from players;
```

```
select
    count(*) as pl_cnt
from dim_player;
```

2. Kreiranje dimenzije datuma i činjenične tabele
Napravite tabelu dim_date na isti način kao na predavanju.
Zatim napravite tabelu fact_player_match na osnovu tabela
player_match_stats i matches. Tabela treba da sadrži
sledeće kolone: match_id, date_key, player_id, team_id,
minutes_played, shots, passes i rating.
U tabelu uključite samo podatke koji se odnose na odigrane
utakmice.
 - Kolika je granularnost tabele fact_player_match, odnosno
 - šta predstavlja jedan njen red?
Koliko redova ima ova tabela?


Resenje: Jedan red ove table predstavlja jedinstvenu kombinaciju
match_id i player_id - jedan igrac moze imati vise redova, ali ne
bi trebalo da ima vise od jedog reda za istu utakmicu


```
CREATE OR REPLACE TABLE dim_date AS
SELECT CAST(DATE_FORMAT(d, 'yyyyMMdd') AS INT) AS date_key,
       d                                       AS full_date,
       DATE_FORMAT(d, 'EEEE')                  AS weekday_name,
       DAYOFWEEK(d) IN (1, 7)                  AS is_weekend,
       CASE WHEN MONTH(d) >= 7 THEN CONCAT(YEAR(d), '/', SUBSTRING(CAST(YEAR(d) + 1 AS STRING), 3, 2))
            ELSE CONCAT(YEAR(d) - 1, '/', SUBSTRING(CAST(YEAR(d) AS STRING), 3, 2))
       END                                     AS season
FROM (SELECT EXPLODE(SEQUENCE(DATE'2023-07-01', DATE'2025-06-30', INTERVAL 1 DAY)) AS d);
```


```
create or replace table fact_player_match as
select
    pms.match_id,
    cast(
        date_format(m.kickoff_ts, 'yyyyMMdd') as int
    ) AS date_key,
    pms.player_id,
    pms.team_id,
    pms.minutes_played,
    pms.shots,
    pms.passes,
    pms.rating
from player_match_stats pms
join matches m
    on pms.match_id = m.match_id
where m.status = 'played';
```

```
select
    count(*) as num_rows
from fact_player_match;
```

3. Prosečna ocena igrača po poziciji
Koristeći napravljene dimenzije i činjeničnu tabelu, izračunajte
prosečnu ocenu (rating) igrača za svaku poziciju tokom sezone 2024/25.
Prikažite poziciju i odgovarajuću prosečnu ocenu.

Resenje:

```
select
    p.position,
    round(avg(f.rating), 2) as avg_rating
from fact_player_match f
join dim_player p
    on f.player_id = p.player_id
join dim_date d
    on f.date_key = d.date_key
where d.season = '2024/25'
    and p.position is not null
    and not isnan(f.rating)
group by p.position
order by avg_rating desc;
```

4. Dodavanje broja golova u činjeničnu tabelu
Proširite tabelu fact_player_match dodavanjem kolone koja
predstavlja broj golova koje je svaki igrač postigao na
određenoj utakmici. Koliki je ukupan zbir golova
svih igrača u tabeli fact_player_match?

Resenje: Ukupan broj golova svih igraca je 2043.

```
alter table fact_player_match
add columns (goals_scored bigint);

update fact_player_match f
set goals_scored = (
    select count(*)
    from match_events e
    where e.match_id = f.match_id
      and e.player_id = f.player_id
      and e.event_type in ('goal', 'penalty_goal')
);
```


```
select
    sum(goals_scored) as total_goals
from fact_player_match;
```
