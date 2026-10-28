# Domaci Zadatak 5.1

1. Za sezonu 2024/25 prikažite igrače i ukupan broj golova
koje su postigli. Prikažite samo igrače koji su postigli bar
jedan gol.

Resenje:

```
with players as (
select
    e.player_id,
    p.first_name,
    p.last_name,
    count(e.event_type) as goals
from matches m
left join match_events e
    on m.match_id = e.match_id
    and e.event_type in ('goal', 'penalty_goal')
    and m.season = '2024/25'
inner join players p
    on p.player_id = e.player_id
group by e.player_id, p.first_name,
    p.last_name
having count(e.event_type) >= 1
)
select
    player_id,
    first_name,
    last_name,
    goals,
    dense_rank() over(order by goals desc) as rnk
from players;
```

Pomoću DENSE_RANK() rangirajte igrače prema ukupnom broju
golova, od najvećeg ka najmanjem. Igrači sa istim brojem golova
treba da imaju isti rang.

2. Za sezonu 2024/25 prikažite tri igrača sa najviše
postignutih golova za svaki klub.

Resenje:

```
with players as (
select
    p.first_name,
    p.last_name,
    t.team_name,
    count(e.event_type) as goals
from matches m
left join match_events e
    on m.match_id = e.match_id
    and e.event_type in ('goal', 'penalty_goal')
    and m.season = '2024/25'
join players p
    on p.player_id = e.player_id
join teams t
    on t.team_id = e.team_id
group by p.player_id, p.first_name, p.last_name, t.team_name
)
select
    team_name,
    first_name,
    last_name,
    goals,
    row_number() over(partition by team_name order by goals desc) as rnk
from players
qualify rnk <= 3
order by team_name, rnk;
```

Prikažite naziv kluba, ime i prezime igrača i broj postignutih
golova. Pomoću ROW_NUMBER() odredite redosled igrača
unutar svakog kluba, od najvećeg ka najmanjem broju golova.

3. Za sezonu 2024/25 prikažite sve utakmice svakog kluba,
broj golova koje je klub postigao i broj golova koje je postigao
u svojoj prethodnoj utakmici.

Pomoću LAG() pronađite broj golova iz prethodne utakmice.
Izračunajte i razliku između broja golova na tekućoj i prethodnoj
utakmici. Rezultate sortirajte po nazivu kluba i datumu
utakmice.

Resenje:


```
with mat as (
select
    m.match_id,
    m.kickoff_ts,
    m.home_team_id as team_id,
    m.home_goals as goals
from matches m
where m.season  = '2024/25'
union all
select
    m.match_id,
    m.kickoff_ts,
    m.away_team_id as team_id,
    m.away_goals as goals
from matches order by t.team_name, m.kickoff_ts;
where m.season = '2024/25'
)
select
    m.team_id,
    t.team_name,
    m.match_id,
    m.kickoff_ts,
    m.goals,
    lag(m.goals) over(partition by t.team_id
        order by m.kickoff_ts, m.match_id) as prev_match_goals,
    m.goals - lag(m.goals) over(partition by t.team_id
        order by m.kickoff_ts, m.match_id) as goal_diff
from mat m
join teams t
    on t.team_id = m.team_id
order by t.team_name, m.kickoff_ts;
```
