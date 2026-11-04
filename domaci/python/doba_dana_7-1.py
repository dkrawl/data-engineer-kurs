# Napisati Python program koji za svaki sat u toku dana
# (od 0 do 23) ispisuje odgovarajuće doba dana:
#
#     noć (od 22 do 6 časova),
#     jutro (od 6 do 12 časova),
#     popodne (od 12 do 18 časova) ili
#     veče (od 18 do 22 časa).


def part_of_day(hour):
    if hour is None:
        return 'None is passed! You can only pass hours!'
    if (hour >= 22 and hour <= 23) or (hour >= 0 and hour < 6):
        return 'Night'
    elif hour >=6 and hour < 12:
        return 'Morning'
    elif hour >= 12 and hour < 18:
        return'Afternoon'
    elif hour >= 18 and hour < 22:
        return 'Evening'
    else:
        return 'Invalid hour! Enter numbers: 0-23'
