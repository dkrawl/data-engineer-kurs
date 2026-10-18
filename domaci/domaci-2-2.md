# Domaci Zadatak 2.2

## SQL fudbalske utakmice

1. Pronađite sve utakmice čiji naslov (`match_report`) sadrži reč `goal`, bez obzira na velika i mala slova.

Resenje:

```
select
    home_team,
    away_team,
    kickoff_ts
from matches_flat
where match_report ilike '%goal%';
```

2. Napravite kolonu `referee_name` tako da sadrži ime sudije ako postoji, a tekst `Unknown`
ako nedostaje podatak. Prikažite 20 utakmica.

Resenje:

```
select
    home_team,
    away_team,
    kickoff_ts,
    coalesce(referee_name, 'Unknown') as referee_name
from matches_flat
limit 20;
```

3. Prikažite utakmice čiji je naslov duži od 40 znakova.
Prikažite naslov i broj znakova u njemu.

Resenje:

```
select
    home_team,
    away_team,
    match_report,
    length(match_report) as match_report_length
from matches_flat
where length(match_report) > 40;
```

4. Prikažite utakmice odigrane od 1. do 15. januara 2025,
uključujući oba datuma.

Resenje:

```
select
    home_team,
    away_team,
    date(kickoff_ts)
from matches_flat
where kickoff_ts >= '2025-01-01' and kickoff_ts <= '2025-01-15';
```

```
select
    home_team,
    away_team,
    date(kickoff_ts)
from matches_flat
where kickoff_ts between '2025-01-01' and '2025-01-15';
```

5. Prebrojte utakmice odigrane petkom. Prikažite datum i
dan u nedelji za svaku od njih.

Resenje: Nijedna utakmica nije odigrana petkom.

```
select
    home_team,
    away_team,
    date(kickoff_ts) as match_date,
    date_format(kickoff_ts, 'EEEE') as day_of_week
from matches_flat
where dayofweek(kickoff_ts) = 6;
```

6. Koliko utakmica sezone `2024/25` je imalo između
20.000 i 35.000 gledalaca, uključujući obe granice?

Resenje: 188.

```
select
    count(*) as matches
from (
    select
        match_id
    from matches_flat
    where season = '2024/25'
    and attendance between 20000 and 35000
) as m;
```

7. Pronađite strelce prvog gola čije ime počinje slovom `A`
ili sadrži crticu. Prikažite samo različita imena.

Resenje:

```
select distinct
    first_goal_scorer
from matches_flat
where first_goal_scorer like 'A%'
or first_goal_scorer like '%-%';
```

8. Prikažite utakmice sezone `2024/25` koje su počele
između 18:00 i 21:00, uključujući obe granice. Prikažite
vreme početka i nazive timova.

Resenje:

```
select
    home_team,
    away_team,
    time(kickoff_ts)
from matches_flat
where season = '2024/25'
and time(kickoff_ts) between '18:00' and '21:00';
```

9. Prebrojte utakmice odigrane u martu, aprilu ili maju
2025 godine čiji naslov sadrži reč `win`, bez obzira na
veličinu slova.

Resenje:

```
select
    count(*) as matches
from (
    select
        match_id
    from matches_flat
    where month(kickoff_ts) in (3, 4, 5)
    and season = '2024/25' and match_report ilike '%win%'
) as m;
```
