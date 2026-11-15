###########################
# Domaći zadatak 10.1
###########################


import pandas as pd

R = '/Volumes/bootcamp/northern_star/raw_2024_26/'
m = pd.read_csv(R + 'matches_2024_26.csv')

#######################################################################################
# 1.  Analiza rezultata utakmica
#######################################################################################

#     1.  Pronaći sve utakmice u kojima su oba tima postigla bar po jedan
#         gol.

both_teams_scored = (
    (m['home_goals'] > 0) & (m['away_goals'] > 0)
)

m.loc[both_teams_scored]
m.loc[both_teams_scored, 'match_id'].value_counts().sum()

#     2.  Pronaći sve utakmice u kojima je domaćin pobedio sa tačno jednim
#         golom razlike.

home_team_won_one_goal_diff = (
    (m['home_goals'] - m['away_goals']) == 1
)

m.loc[home_team_won_one_goal_diff]
m.loc[home_team_won_one_goal_diff, 'match_id'].value_counts().sum()

#     3.  Koliko utakmica je završeno rezultatom 0:0?

matches_without_goals = (
    (m['home_goals'] == 0) & (m['away_goals'] == 0)
)

m.loc[matches_without_goals, 'match_id'].value_counts().sum()
# m.loc[matches_without_goals].shape

#     4.  Prikazati 10 utakmica sa najviše ukupno postignutih golova.

m['total_goals'] = m['home_goals'] + m['away_goals']
m.sort_values(by='total_goals', ascending=False)[:10]


#######################################################################################
# 2.  Analiza jednog tima
# Za tim po izboru:
#######################################################################################

#     1.  Prikazati sve utakmice u kojima je učestvovao.

all_matches_bmc_team = (
    (m['home_team'] == 'BMC') | (m['away_team'] == 'BMC')
)

bmc = m.loc[all_matches_bmc_team].copy()

#     2.  Koliko je puta pobedio, izgubio i odigrao nerešeno?

bmc_wins = (
    ((bmc['home_team'] == 'BMC')
    & (bmc['home_goals'] > bmc['away_goals']))
    |
    ((bmc['away_team'] == 'BMC')
    & (bmc['home_goals'] < bmc['away_goals']))
)

bmc_draws = (
    ((bmc['home_team'] == 'BMC')
    & (bmc['home_goals'] == bmc['away_goals']))
    |
    ((bmc['away_team'] == 'BMC')
    & (bmc['home_goals'] == bmc['away_goals']))
)

bmc.loc[bmc_wins, 'result'] = 'W'
bmc.loc[bmc_draws, 'result'] = 'D'
bmc.loc[~(bmc_wins | bmc_draws), 'result'] = 'L'

bmc.loc[bmc['result'] == 'W', 'match_id'].value_counts().sum()   # 17 wins
bmc.loc[bmc['result'] == 'D', 'match_id'].value_counts().sum()   # 8 draws
bmc.loc[bmc['result'] == 'L', 'match_id'].value_counts().sum()   # 13 losses

#      3.  Koliko je golova postigao kao domaćin, a koliko kao gost?

bmc_home = (
    bmc['home_team'] == 'BMC'
)

bmc_away = (
    bmc['away_team'] == 'BMC'
)

bmc.loc[bmc_home, 'home_goals'].sum()    # 32 goals
bmc.loc[bmc_away, 'away_goals'].sum()    # 19 goals

#      4.  Pronaći utakmicu u kojoj je postigao najviše golova.

bmc['bmc_goals'] = bmc['home_goals']
bmc.loc[bmc_away, 'bmc_goals'] = bmc['away_goals'] # uses bmc_away condition above
bmc.sort_values(by='bmc_goals', ascending=False)[:1]


#######################################################################################
# 3.  Analiza stadiona
#######################################################################################

#     1.  Prikazati sve različite stadione na kojima su odigrane utakmice.

m['stadium'].unique()

#     2.  Pronaći stadion na kojem je odigrano najviše utakmica.

m['stadium'].value_counts(ascending=False)

#     3.  Za svaki stadion izračunati prosečnu posećenost.

# My first approach is to use the dictionary:

stadiums = m['stadium'].unique()
avg_attendance = {}

for stadium in stadiums:
    avg_attendance[stadium] = m.loc[m['stadium'] == stadium, 'attendance'].mean()

print(avg_attendance)

# The second approach uses the DataFrame:

for stadium in stadiums:
    m.loc[m['stadium'] == stadium, 'average_attendance'] = round(m.loc[m['stadium'] == stadium, 'attendance'].mean())

m[['stadium', 'average_attendance']].drop_duplicates()

#     4.  Prikazati pet stadiona sa najvećom prosečnom posećenošću.

m.sort_values(by='average_attendance', ascending=False)[['stadium', 'average_attendance']].drop_duplicates().head(5)
