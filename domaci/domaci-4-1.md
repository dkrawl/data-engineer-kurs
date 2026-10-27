# Domaci Zadatak 4.1

1. Koliko redova ima spoj matches i player_match_stats za sezonu 2024/25? Objasnite.

Resenje:

```
select
    count(*) as `broj redova`
from matches m
join player_match_stats s
where m.season = '2024/25';
```

Spoj ima 11,567,200 redova. Ovaj veliki broj redova se dobija tako sto se pomnozi
broj redova tabele matches za sezonu 2024/25 sa brojem redova u player_match_stats:

```
select count(*) from matches where season = '2024/25'
```

Ovaj upit daje 380 redova.

```
select count(*) from player_match_stats;
```

Ovaj upit daje 30,440 redova.

Ukupan broj redova spoja je 380 x 30,440 = 11,567,200.

2. Koliko puta je igrač u istoj sezoni igrao za dva različita kluba?

Resenje: 35.

```
select
    s.player_id,
    m.season,
    count(distinct s.team_id) as club_ct
from matches m
join player_match_stats s
    on m.match_id = s.match_id
group by s.player_id, m.season
having count(distinct s.team_id) >= 2;
```


3. Koliko utakmica ima više kartona od prosečne utakmice? Bez
kartona računajte sa 0.

Resenje: 370.


```
with m as (
select
    m.match_id,
    count(e.match_id) as cards
from matches m
left join match_events e
    on m.match_id = e.match_id
    and e.event_type in ('yellow_card', 'second_yellow', 'red_card')
group by m.match_id
),
averages as (
    select
        match_id,
        cards,
        avg(cards) over() as avg_cards
    from m
)
select
    count(*) as above_avg
from averages
where cards > avg_cards;
```

4. Koliko igrača je odigralo više od 10 utakmica u sezoni
2024/25?

Resenje: 383.

```
with players as (
select
    s.player_id,
    count(distinct m.match_id) as match_count
from matches m
join player_match_stats s
    on m.match_id = s.match_id
where m.season = '2024/25'
    and s.minutes_played > 0
group by s.player_id
having count(distinct m.match_id) > 10
)
select count(*) as player_count
from players;
```

5. Prikažite sve klubove koji su igrali u sezoni 2024/25, bilo kao
domaćini ili kao gosti. Koristite UNION, a zatim izmenite upit
tako da koristi UNION ALL. Objasnite razliku u broju redova koji
dobijate.

Resenje: kombinovani upit sa union vrace jedinstvene timove (brise duplikate) i broj redova je 20, a upit sa union all
vraca sve redove i broj redova je 760 (redovi iz prvog upita i redovi iz drugog upita - 380 + 380).

```
with clubs as (
select
    home_team_id as team_id
from matches
where season = '2024/25'
union
select
    away_team_id as team_id
from matches
where season = '2024/25'
)
select
    t.team_id,
    t.team_name
from clubs c
inner join teams t
    on c.team_id = t.team_id;
```
