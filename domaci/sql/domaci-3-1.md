# Domaci Zadatak 3.1

1. Za svaku sezonu prikažite ukupan broj utakmica, ukupan broj
postignutih golova i prosečan broj golova po utakmici.

Resenje:

```
select
    season,
    count(*) total_matches,
    sum(home_goals + away_goals) total_goals,
    round(avg(home_goals + away_goals), 2) avg_goals_per_match
from matches
group by season;
```


2. Za svaki stadion prikažite najmanju, najveću i prosečnu zabeleženu
posetu, kao i broj utakmica za koje je poseta poznata.

Resenje:

```
select
    s.stadium_name,
    max(m.attendance) max_attendance,
    min(m.attendance) min_attendance,
    count(m.attendance) as matches_with_att_known
from matches m
inner join stadiums s
    on s.stadium_id = m.stadium_id
group by
    s.stadium_name
```


3. Prikažite sudije koje su sudile najmanje 10 utakmica i koje su
ukupno pokazale najmanje 20 žutih kartona. Prikažite ime sudije, broj
utakmica i ukupan broj žutih kartona.

Resenje:

```
select
    r.referee_name,
    count(distinct m.match_id) as total_matches,
    sum(
        case
            when e.event_type in ('yellow_card', 'second_yellow')
            then 1
            else 0
        end
    ) total_yellow_cards
from matches m
inner join referees r
    on m.referee_id = r.referee_id
inner join match_events e
    on m.match_id = e.match_id
group by
    r.referee_name
having
    count(distinct m.match_id) >= 10
    and sum(
        case
            when
                e.event_type in ('yellow_card', 'second_yellow')
            then 1
            else 0
        end
    ) >= 20
order by
    total_yellow_cards desc;
```


4. Podelite utakmice prema ukupnom broju golova na kategorije Bez
golova (0), Malo golova (1 ili 2) i Mnogo golova (3 ili više). Prikažite
broj utakmica u svakoj kategoriji i najveći broj golova na utakmici u
toj kategoriji.

Resenje: Ukljucio sam i kategoriju 'Nepoznato' da mozemo da ukljucimo i utakmice
gde su ili home_goals null ili away_goals null, ili oba su null.

```
select
    case
        when (home_goals + away_goals) >= 3
            then 'Mnogo golova'
        when (home_goals + away_goals) in (1, 2)
            then 'Malo golova'
        when (home_goals + away_goals) = 0
            then 'Bez golova'
        else 'Nepoznato'
    end `Kategorija`,
    count(*) `Ukupan broj utakmica`,
    max(home_goals + away_goals) `Najveci broj golova`
from matches
group by `Kategorija`;
```


5. Za svaki klub prikažite broj utakmica koje je odigrao kao domaćin,
broj pobeda kod kuće i broj poraza kod kuće. U rezultat uključite
samo klubove koji su kod kuće odigrali najmanje 10 utakmica.

Resenje:

```
select
    t.team_name,
    count(m.match_id) as home_matches,
    sum (
        case
            when home_goals > away_goals
                then 1
            else 0
        end) home_wins,
    sum (
        case
            when home_goals < away_goals
                then 1
            else 0
        end
    ) home_losses
from matches m
inner join teams t
    on m.home_team_id = t.team_id
group by
    t.team_name
having count(m.match_id) >= 10;
```


6. Za svakog sudiju prikažite ukupan broj utakmica, broj utakmica u
kojima je pokazao bar jedan crveni karton i procenat takvih utakmica
u odnosu na sve utakmice koje je sudio.

Resenje:

```
select
    r.referee_name,
    count(distinct m.match_id) total_matches,
    count(
        distinct case
            when e.event_type = 'red_card'
                then m.match_id
            else null
        end
        ) as red_card_match,
        round (
            100 * count(
                distinct case
                    when e.event_type = 'red_card'
                        then m.match_id
                    else null
                end
            ) / nullif(count(distinct m.match_id), 0), 2)
            as red_card_match_pct
from matches m
inner join referees r
    on m.referee_id = r.referee_id
inner join match_events e
    on m.match_id = e.match_id
group by
    r.referee_name;
```


7. Za svaku sezonu prikažite broj pobeda domaćina, broj nerešenih
utakmica i broj pobeda gostiju. Takođe prikažite procenat utakmica
koje su završene nerešenim rezultatom.

Resenje:

```
select
    season,
    sum(
        case
            when home_goals > away_goals then 1
            else 0
        end
    ) home_wins,
    sum(
        case
            when home_goals = away_goals then 1
            else 0
        end
    ) draws,
    sum(
        case
            when home_goals < away_goals then 1
            else 0
        end
    ) away_wins,
    round(
        100.0 * sum(
            case
                when home_goals = away_goals then 1
                else 0
            end
        )
        / nullif(count(match_id), 0), 2)
        draw_match_pct
from matches
group by season;
```
