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
where kickoff_ts >= '2025-01-01' and kickoff_ts < '2025-01-16';
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
from matches_flat
where season = '2024/25'
and attendance between 20000 and 35000;
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
from matches_flat
where month(kickoff_ts) in (3, 4, 5)
and season = '2024/25'
and match_report ilike '%win%';
```

Dodatni Zadaci (Opciono)

1. Prebrojte utakmice za koje nisu evidentirani ni sudija ni poseta.

Resenje: 0.

```
select
    count(*) as matches
from matches_flat
where referee_name is null
and attendance is null;
```

2. Prikažite sve utakmice odigrane između 1. i 31. marta 2025.
godine, uključujući oba datuma. Rezultate sortirajte po datumu
odigravanja.

Resenje:

```
select
    home_team,
    away_team,
    kickoff_ts
from matches_flat
where kickoff_ts >= '2025-03-01'
and kickoff_ts < '2025-04-01'
order by kickoff_ts asc;
```

3. Koliko je utakmica odigrano u periodu od 20. decembra 2024.
do 10. januara 2025. godine, uključujući oba datuma?

Resenje: 51.

```
select
    count(*) as matches
from matches_flat
where kickoff_ts >= '2024-12-20 00:00:00'
and kickoff_ts < '2025-01-11 00:00:00';
```

4. Napravite kolonu attendance_status koja prikazuje broj
gledalaca ako je poseta evidentirana, a tekst Unknown ako
podatak o poseti nedostaje. Prikažite datum utakmice, domaći
tim, gostujući tim i novu kolonu.

Resenje:

```
select
    kickoff_ts,
    home_team,
    away_team,
    coalesce(cast(attendance as string), 'Unknown') as attendance_status
from matches_flat;
```

5. Prikažite utakmice odigrane u periodu od 1. do 30. aprila 2025.
godine kod kojih je postignuto između 2 i 4 gola ukupno,
uključujući obe granice. Rezultate sortirajte po datumu.

Resenje:

```
select
    home_team,
    away_team,
    kickoff_ts
from matches_flat
where kickoff_ts >= '2025-04-01 00:00:00'
and kickoff_ts < '2025-05-01 00:00:00'
and (home_goals + away_goals) between 2 and 4
order by kickoff_ts asc;
```

6.Pronađite utakmice kod kojih je rezultat na poluvremenu bio
nerešen, ali je konačni rezultat bio različit. Prikažite datum, timove,
rezultat na poluvremenu i konačni rezultat.

Resenje:

```
select
    home_team,
    away_team,
    kickoff_ts,
    concat(home_goals_ht, '-', away_goals_ht) as half_time,
    concat(home_goals, '-', away_goals) as full_time
from matches_flat
where home_goals_ht = away_goals_ht
and home_goals <> away_goals;
```
