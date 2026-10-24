-- Domaci Zadatak - Radionica - Dosije
--
-- Вежба 2 — досије клуба
--
-- Изаберите један клуб и анализирајте његову сезону 2024/25. Сваки упит почните истим кораком, тако да
-- за други клуб мењате само име:

WITH club AS (
  SELECT team_id FROM teams WHERE team_name = 'име вашег клуба'
)
SELECT ...

-- 1. Сезона у бројевима: утакмице, победе, нерешене, порази, дати и примљени голови, бодови.
-- 2. Код куће и у гостима: исти бројеви, одвојено за домаће и гостујуће утакмице.
-- 3. Стрелци: три најбоља стрелца клуба и најбољи асистент.
-- 4. Дисциплина: картони клуба по утакмици у поређењу са просеком лиге по тиму по утакмици.
-- 5. Тренери: ко је водио клуб у сезони и са колико бодова по утакмици.
-- 6. Највећа победа и најтежи пораз.
-- 7. Публика: просечна посета и попуњеност на домаћим утакмицама, и колико утакмица нема
-- податак о посети.
--
-- Све упите сачувајте у један SQL фајл, на пример workshop/dossier.sql, и пошаљите га у свој
-- репозиторијум sql-bootcamp (commit и push). На крају припремите један најзанимљивији налаз о свом
-- клубу.
--
-- Resenje:

-- 1. Сезона у бројевима: утакмице, победе, нерешене, порази, дати и примљени голови, бодови.

```
with club as (
    select team_id from teams where team_name = 'Northport United'
)
select
    count(m.match_id) as `broj utakmica`,
    sum(
        case
            when c.team_id = m.home_team_id
            and m.home_goals > m.away_goals
            then 1
            else 0
        end
    ) +
    sum(
        case
            when c.team_id = m.away_team_id
            and m.home_goals < m.away_goals
            then 1
            else 0
        end
    ) as `pobede`,
        sum(
        case
            when c.team_id = m.home_team_id
            and m.home_goals = m.away_goals
            then 1
            else 0
        end
    ) +
    sum(
        case
            when c.team_id = m.away_team_id
            and m.home_goals = m.away_goals
            then 1
            else 0
        end
    ) as `neresene utakmice`,
        sum(
        case
            when c.team_id = m.home_team_id
            and m.home_goals < m.away_goals
            then 1
            else 0
        end
    ) +
    sum(
        case
            when c.team_id = m.away_team_id
            and m.home_goals > m.away_goals
            then 1
            else 0
        end
    ) as `porazi`,
    sum(
        case
            when c.team_id = m.home_team_id
            then m.home_goals
            else 0
        end
    ) +
    sum(
        case
            when c.team_id = m.away_team_id
            then m.away_goals
            else 0
        end
    ) as `dati golovi`,
    sum(
        case
            when c.team_id = m.home_team_id
            then m.away_goals
            else 0
        end
    ) +
    sum(
        case
            when c.team_id = m.away_team_id
            then m.home_goals
            else 0
        end
    ) as `primljeni golovi`,
    sum(
        case
            when c.team_id = m.home_team_id
                and m.home_goals > m.away_goals
                then 3
            when c.team_id = m.home_team_id
                and m.home_goals = m.away_goals
                then 1
            else 0
        end
    ) +
    sum(
        case
            when c.team_id = m.away_team_id
                and m.home_goals < m.away_goals
                then 3
            when c.team_id = m.away_team_id
                and m.home_goals = m.away_goals
                then 1
            else 0
        end
    ) as `bodovi`
from club c
inner join matches m
    on c.team_id = m.home_team_id
    or c.team_id = m.away_team_id
where m.season = '2024/25';
```

-- 2. Код куће и у гостима: исти бројеви, одвојено за домаће и гостујуће утакмице.

-- Kod kuce:

```
with club as (
    select team_id from teams where team_name = 'Northport United'
)
select
    count(m.match_id) as `broj utakmica kod kuce`,
    sum(
        case
            when m.home_goals > m.away_goals
            then 1
            else 0
        end
    ) as `pobede kod kuce`,
    sum(
        case
            when m.home_goals = m.away_goals
            then 1
            else 0
        end
    ) as `neresene utakmice`,
    sum(
        case
            when m.home_goals < m.away_goals
            then 1
            else 0
        end
    ) as `porazi`,
    sum(m.home_goals) as `dati golovi`,
    sum(m.away_goals) as `primljeni golovi`,
    sum(
        case
            when m.home_goals > m.away_goals
                then 3
            when m.home_goals = m.away_goals
                then 1
            else 0
        end
    ) as `bodovi`
from club c
inner join matches m
    on c.team_id = m.home_team_id
where m.season = '2024/25';
```

-- U gostima:

```
with club as (
    select team_id from teams where team_name = 'Northport United'
)
select
    count(m.match_id) as `broj utakmica u gostima`,
    sum(
        case
            when m.home_goals < m.away_goals
            then 1
            else 0
        end
    ) as `pobede u gostima`,
    sum(
        case
            when m.home_goals = m.away_goals
            then 1
            else 0
        end
    ) as `neresene utakmice`,
    sum(
        case
            when m.home_goals > m.away_goals
            then 1
            else 0
        end
    ) as `porazi`,
    sum(m.away_goals) as `dati golovi`,
    sum(m.home_goals) as `primljeni golovi`,
    sum(
        case
            when m.home_goals < m.away_goals
                then 3
            when m.home_goals = m.away_goals
                then 1
            else 0
        end
    ) as `bodovi`
from club c
inner join matches m
    on c.team_id = m.away_team_id
where m.season = '2024/25';
```

-- 3. Стрелци: три најбоља стрелца клуба и најбољи асистент.
--
-- Tri najbolja strelca:

```
with club as (
    select team_id from teams where team_name = 'Northport United'
)
select
    p.first_name,
    p.last_name,
    count(*) as `broj golova`
from club c
inner join match_events e
    on c.team_id = e.team_id
inner join players p
    on p.player_id = e.player_id
inner join matches m
    on m.match_id = e.match_id
where e.event_type in ('goal', 'penalty_goal')
    and m.season = '2024/25'
group by
    p.first_name,
    p.last_name
order by `broj golova` desc
limit 3;
```

-- Najbolji asistent:

```
with club as (
    select team_id from teams where team_name = 'Northport United'
)
select
    p.first_name,
    p.last_name,
    count(*) as `broj asistencija`
from club c
inner join match_events e
    on c.team_id = e.team_id
inner join players p
    on p.player_id = e.related_player_id
inner join matches m
    on m.match_id = e.match_id
where e.event_type in ('goal', 'penalty_goal')
    and m.season = '2024/25'
group by
    p.first_name,
    p.last_name
order by `broj asistencija` desc
limit 1;
```

-- 4. Дисциплина: картони клуба по утакмици у поређењу са просеком лиге по тиму по утакмици.

-- Kartoni kluba po utakmici:

```
with club as (
    select team_id, team_name from teams where team_name = 'Northport United'
)
select
    c.team_name,
    round(
        count(e.match_id) / count(distinct m.match_id), 2) as `broj kartona po utakmici`
from club c
inner join matches m
    on c.team_id = m.home_team_id
    or c.team_id = m.away_team_id
left join match_events e
    on m.match_id = e.match_id
    and c.team_id = e.team_id
    and e.event_type in ('yellow_card', 'second_yellow', 'red_card')
where m.season = '2024/25'
group by c.team_name;
```

-- Northport United ima prosek 1.74 kartona po mecu.

-- Prosek kartona po  utakmici za celu ligu:

```
with team_cards as (
    select
        t.team_name,
        round (
            count(e.match_id) / count(distinct m.match_id), 2) as `broj kartona po utakmici`
    from teams t
    inner join matches m
        on t.team_id = m.home_team_id
        or t.team_id = m.away_team_id
    left join match_events e
        on t.team_id = e.team_id
        and m.match_id = e.match_id
        and e.event_type in ('yellow_card', 'second_yellow', 'red_card')
    where m.season = '2024/25'
    group by t.team_name
)
select
    round(avg(`broj kartona po utakmici`), 2) as `prosek kartona po utakmici za ligu`
from team_cards;
```

-- Cela liga ima prosek kartona 1.74 po mecu. Northport United ima identican prosek kartona po mecu proseku lige.

-- 5. Тренери: ко је водио клуб у сезони и са колико бодова по утакмици.
