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

-- Statistika za Northport United za sezonu 2024/25:
-- broj utakmica: 38
-- pobede: 18
-- neresene: 6
-- porazi: 14
-- dati golovi: 69
-- primljeni golovi: 52
-- bodovi: 60


-- 2. Код куће и у гостима: исти бројеви, одвојено за домаће и гостујуће утакмице.

-- Kod kuce:

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

-- Statistika Northport United kluba kod kuce:
-- broj utakmica: 19
-- pobede: 11
-- neresene: 3
-- porazi: 5
-- dati golovi: 41
-- primljeni golovi: 26
-- bodovi: 36

-- U gostima:

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

-- Statistika Northport United kluba u gostima:
-- broj utakmica: 19
-- pobede: 7
-- neresene: 3
-- porazi: 9
-- dati golovi: 28
-- primljeni golovi: 26
-- bodovi: 24


-- 3. Стрелци: три најбоља стрелца клуба и најбољи асистент.
--
-- Tri najbolja strelca:

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

-- Najbolji asistent:

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

-- Tri najbolja strelca:
-- Leo Marsh: 32 postignuta gola
-- Javier Navarro: 6 postignutih golova
-- Pablo Fernandez: 6 postignutih golova

-- Najbolji asistent:
-- Pablo Fernandez: 9 asistencija


-- 4. Дисциплина: картони клуба по утакмици у поређењу са просеком лиге по тиму по утакмици.

-- Kartoni kluba po utakmici:

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

-- Prosek kartona po  utakmici za celu ligu:

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

-- Cela liga ima prosek kartona 1.74 po mecu. Northport United ima identican prosek kartona po mecu kao prosek lige.

-- 5. Тренери: ко је водио клуб у сезони и са колико бодова по утакмици.

with club as (
    select team_id, team_name from teams where team_name = 'Northport United'
),
manager_points as (
select
    s.manager_name,
    m.match_id,
    case
        when m.home_team_id = c.team_id
        and m.home_goals > m.away_goals
        then 3
        when m.home_team_id = c.team_id
        and m.home_goals = m.away_goals
        then 1
        when m.away_team_id = c.team_id
        and m.home_goals < m.away_goals
        then 3
        when m.away_team_id = c.team_id
        and m.home_goals = m.away_goals
        then 1
        else 0
    end
    as `bodovi`
from club c
inner join manager_spells s
    on c.team_id = s.team_id
inner join matches m
    on (c.team_id = m.home_team_id
    or c.team_id = m.away_team_id)
    and m.kickoff_ts >= s.start_date
    and m.kickoff_ts < coalesce(s.end_date, timestamp '9999-12-12')
    and m.season = '2024/25'
)
select
    manager_name,
    round(avg(`bodovi`), 2) as `prosek bodova po utakmici`
from manager_points
group by manager_name;

-- Klub Northport United je vodio Thomas Frank sa 1.58 bodova po utakmici.


-- 6. Највећа победа и најтежи пораз.

with club as (
    select team_id, team_name from teams where team_name = 'Northport United'
),
club_goal_diff as (
select
    c.team_name,
    m.home_goals,
    m.away_goals,
    case
        when c.team_id = m.home_team_id
        then 'domacin'
        else 'gost'
    end as `gde je igrao`,
    concat(home_goals, '-', away_goals) as `rezultat utakmice`,
    case
        when c.team_id = m.home_team_id
        then m.home_goals - m.away_goals
        else m.away_goals - m.home_goals
    end as `razlika u golovima`
from club c
inner join matches m
    on (c.team_id = m.home_team_id
    or c.team_id = m.away_team_id)
    and m.season = '2024/25'
)
select
    team_name,
    `gde je igrao`,
    `rezultat utakmice`
from club_goal_diff
where `razlika u golovima` = (select max(`razlika u golovima`) from club_goal_diff)
    or `razlika u golovima` = (select min(`razlika u golovima`) from club_goal_diff)
order by `razlika u golovima` desc;

-- Najvecu pobedu je Northport United ostvario kao domacin (i kao gost) sa gol razlikom 4.
-- Najveci poraz je doziveo kod kuce gol razlikom 4.


-- 7. Публика: просечна посета и попуњеност на домаћим утакмицама, и колико утакмица нема
-- податак о посети.

with club as (
    select team_id, team_name from teams where team_name = 'Northport United'
),
club_matches as (
select
    c.team_name,
    m.attendance,
    s.capacity
from club c
inner join matches m
    on c.team_id = m.home_team_id
    and m.season = '2024/25'
inner join stadiums s
    on s.stadium_id = m.stadium_id
)
select
    team_name,
    round(avg(attendance)) as `prosecna poseta`,
    round(100 * avg(attendance) / max(capacity)) as `popunjenost %`,
    sum(
        case
            when attendance is null
            then 1
            else 0
        end
    ) as `utakmice bez podatka o poseti`
from club_matches
group by team_name;

-- Prosecna poseta na domacim utakmicama je 44074 a popunjenost oko 85%. Nema domacih utakmica bez podataka o poseti.
-- Ako ukljucimo i utakmice u gostima, onda imamo jednu utakmicu bez podataka o poseti.
