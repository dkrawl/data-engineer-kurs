# Problemi za vezbanje
#
# 0.1. Napisati program kojim se prevodi temperatura iz Celzijusove skale u Farenhajtovu skalu,
# ako je odgovaraju ́ca formula oblika T[◦F] = T[◦C] · 1.80 + 32. Na ulazu se unosi vrednost
# temperature u stepenima Celzijusa (realan broj) a ispisuje se vrednost temperature u stepenima
# Farenhajta.

def cels_to_fahr(temp):
    return temp * 1.8 + 32

# 0.2. Napisati program koji za uneti redni broj dana u nedelji (od 1 do 7) ispisuje naziv tog
# dana (ponedeljak - nedelja). Ukoliko je unet broj koji nije izmed ̄u 1 i 7, ispisati Pogresan
# unos.


def day_of_the_week(day):
    if day is None or day < 1 or day > 7 :
        return 'Wrong day: you can only add days from 1 to 7'
    elif day == 1:
        return 'Monday'
    elif day == 2:
        return 'Tuesday'
    elif day == 3:
        return 'Wednesday'
    elif day == 4:
        return 'Thursday'
    elif day == 5:
        return 'Friday'
    elif day == 6:
        return 'Saturday'
    else:
        return 'Sunday'


# 0.3. Napisati program koji racuna najveci negativni element u listi.

def max_negative_number(l):
    max_n = 0
    for x in l:
        if x < 0:
            if max_n == 0 or x > max_n:
                max_n = x
    return max_n

# 0.5. Napicsati program koji racuna broj parnih elemenata date liste.

def evens(l):
    count = 0
    for x in l:
        if x % 2 == 0:
            count += 1
    return count

# 0.6. Napisati program koji racuna sume elemenata liste celih brojeva koji su deljivi sa 2 odnosno
# sa 3.

def sum_divisible_by_2_or_3(l):
    sum = 0
    if l is not None:
        for x in l:
            if x % 2 == 0 or x % 3 == 0:
                sum += x
    return sum
