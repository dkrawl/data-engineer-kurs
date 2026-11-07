# Domaci Zadatak 5.2

1. Prosek datih golova u poslednjih 5 utakmica, uz izričit
okvir prozora. Koja je najveća vrednost? Računajte
samo kada prozor zaista ima 5 utakmica.

Resenje: Prosek datih golova u poslednjih 5 utakmica je 3.6.
Najveci prosek je 5.

```
with mat as (
select
    match_id,
    kickoff_ts,
    home_goals + away_goals as goals
from matches
),
avg as (
select
    match_id,
    kickoff_ts,
    goals,
    avg(goals) over(
        order by kickoff_ts, match_id
        rows between 4 preceding and current row
    ) as avg_goals_last_five
from mat
order by kickoff_ts desc
)
select
    avg_goals_last_five,
    max(avg_goals_last_five) over() as max_avg_goals_five
from avg
limit 1;
```

2. Tekući zbir datih golova svakog kluba u sezoni
2024/25: ko je prvi stigao do 50 golova i kada?

Resenje: Kingbridge City je postigao 51 gol na dan 18.01.2025.


```
with tm as (
select
    match_id,
    kickoff_ts,
    home_team_id as team_id,
    home_goals as goals
from matches
where season = '2024/25'
union all
select
    match_id,
    kickoff_ts,
    away_team_id as team_id,
    away_goals as goals
from matches
where season = '2024/25'
),
fifty as(
select
    m.match_id,
    m.kickoff_ts,
    m.team_id,
    t.team_name,
    sum(m.goals) over(partition by m.team_id order by m.kickoff_ts, m.match_id)
    as running_total
from tm m
join teams t
    on m.team_id = t.team_id
qualify running_total >= 50
)
select
    match_id,
    kickoff_ts,
    team_name,
    running_total,
    row_number() over(partition by team_id order by kickoff_ts, match_id) as rnk
from fifty
qualify rnk = 1
order by kickoff_ts asc;
```

3. Za svaku domaću utakmicu izračunajte promenu
posećenosti u odnosu na prethodnu domaću utakmicu
istog kluba u istoj sezoni. Gde je najveći pad i zašto?

Resenje: Najveci pad posecenosti je na utakmici Oakfield Town: 17864.
Ovo je najveca razlika zato sto je posecenost u prethodnoj utakmici bila 0.


```
select
    m.match_id,
    m.home_team_id,
    t.team_name as home_team,
    m.season,
    m.attendance,
    lag(m.attendance) over(partition by m.home_team_id, m.season order by m.kickoff_ts, m.match_id) prev_attendance,
    m.attendance -  lag(m.attendance) over(partition by m.home_team_id, m.season order by m.kickoff_ts, m.match_id) as att_diff
from matches m
join teams t
    on t.team_id = m.home_team_id
order by att_diff asc nulls last;
```
