# Domaci Zadatak 3.2

Osnovni nivo:
1.Prikažite naziv svakog kluba i naziv stadiona na kojem igra
domaće utakmice.

Resenje:

```
select
    t.team_name,
    s.stadium_name
from teams t
inner join stadiums s
    on t.stadium_id = s.stadium_id;
```

2.Prikažite ime i prezime igrača i naziv kluba za koji je igrao u
sezoni 2024/25. Uklonite duplikate iz rezultata.

Resenje:

```
select distinct
    p.first_name,
    p.last_name,
    t.team_name
from matches m
inner join player_match_stats ps
    on m.match_id = ps.match_id
    and m.season = '2024/25'
inner join players p
    on p.player_id = ps.player_id
inner join teams t
    on t.team_id = ps.team_id;
```

3.Prikažite datum odigravanja utakmice, naziv stadiona i broj
gledalaca za sve utakmice u sezoni 2024/25.

Resenje:

```
select
    date(m.kickoff_ts) as match_date,
    s.stadium_name,
    m.attendance
from matches m
inner join stadiums s
    on m.stadium_id = s.stadium_id
where m.season = '2024/25';
```

Srednji nivo:

1.Prikažite sve utakmice za koje nije evidentiran broj gledalaca.
Prikažite datum, domaći klub i gostujući klub.

Resenje:

```
select
    date(m.kickoff_ts) match_date,
    t.team_name home_team,
    te.team_name away_team
from matches m
inner join teams t
    on m.home_team_id = t.team_id
inner join teams te
    on m.away_team_id = te.team_id
where m.attendance is null;
```

2.Pronađite stadione na kojima nije odigrana ni jedna utakmica
u sezoni 2024/25.

Resenje:

```
select
    s.stadium_name
from stadiums s
left join matches m
    on s.stadium_id = m.stadium_id
    and m.season = '2024/25'
where m.match_id is null;
```

3.Za svaki klub izračunajte ukupan broj žutih kartona koje su
dobili njegovi igrači u sezoni 2024/25. Rezultat sortirajte
opadajuće prema broju kartona.

Resenje:

```
select
    t.team_name,
    sum(
        case
            when e.event_type in ('yellow_card', 'second_yellow')
            then 1
            else 0
        end
    ) total_yellow_cards
from matches m
inner join player_match_stats s
    on m.match_id = s.match_id
inner join teams t
    on s.team_id = t.team_id
inner join match_events e
    on m.match_id = e.match_id
    and e.player_id = s.player_id
where m.season = '2024/25'
group by
    t.team_name
order by
    total_yellow_cards desc;
```

Napredni nivo:

1.Pronađite pet igrača sa najvećim brojem asistencija u
sezoni 2024/25. Prikažite ime igrača i broj asistencija.

Resenje:

```
select
    p.first_name,
    p.last_name,
    count(*) as assists
from matches m
inner join match_events e
    on m.match_id = e.match_id
inner join players p
    on e.related_player_id = p.player_id
where season = '2024/25'
    and e.event_type = 'goal'
    and e.related_player_id is not null
group by
    p.first_name,
    p.last_name
order by assists desc
limit 5;
```

2.Pronađite tri igrača sa najvećim ukupnim brojem
odigranih minuta u sezoni 2024/25. Prikažite ime igrača,
klub i ukupan broj minuta.

Resenje:


```
select
    p.first_name,
    p.last_name,
    t.team_name,
    sum(s.minutes_played) minutes_played
from matches m
inner join player_match_stats s
    on m.match_id = s.match_id
inner join teams t
    on s.team_id = t.team_id
inner join players p
    on s.player_id = p.player_id
where
    m.season = '2024/25'
group by
    p.first_name,
    last_name,
    t.team_name
order by minutes_played desc
limit 3;
```

3.Za svaku sezonu prikažite broj isključenja po klubovima.
Računajte događaje red_card i second_yellow. Uključite
samo klubove koji su imali najmanje jedno isključenje

Resenje:

```
select
    m.season,
    t.team_name,
    count(*) `iskljucenja`
from matches m
inner join match_events e
    on m.match_id = e.match_id
inner join teams t
    on e.team_id = t.team_id
where e.event_type in ('red_card', 'second_yellow')
group by
    m.season,
    t.team_name
order by
    m.season,
    `Iskljucenja` desc;
```
