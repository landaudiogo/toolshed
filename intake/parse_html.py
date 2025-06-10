from bs4 import BeautifulSoup
from itertools import permutations

IGNORE = "Diogo Landau"

with open('datumprikker.html', 'r') as f: 
    content = f.read()

soup = BeautifulSoup(content, 'html.parser')

availabilities = {}
timeslots = set()

slots = soup.find_all(**{'class': 'eventdate'})
for slot in slots: 
    date_div = slot.find(**{'class': 'date'})
    slot_str = f'{date_div["data-startdate"]} => {date_div["data-enddate"]}'
    responses = slot.find(**{'class': 'all_responses'})
    yes = responses.find(**{'class': 'responses responses_yes'})
    maybe = responses.find(**{'class': 'responses responses_maybe'})
    no = responses.find(**{'class': 'responses responses_no'})
    for span in yes.find_all(**{'class': 'name'}):
        name = span.string.strip()
        if name == IGNORE: 
            continue
        availabilities.setdefault(name, set()).add(slot_str)
        timeslots.add(slot_str)


earliest_finish = None
candidates = []
students = list(availabilities.keys())
timeslots = list(timeslots)
timeslots.sort()
for p in permutations(timeslots, len(students)):
    success = True
    for i, timeslot in enumerate(p):
        if timeslot not in availabilities[students[i]]:
            success = False
            break

    if not success: 
        continue

    if (earliest_finish is not None) and (max(p) > earliest_finish):
        continue

    earliest_finish = max(p)
    candidate = [] 
    for i, timeslot in enumerate(p):
        match_str = f'{timeslot} = {students[i]}'
        candidate.append(match_str)
    candidates.append(candidate)

for candidate in candidates:
    candidate.sort()
    print("\n")
    for timeslot in candidate:
        print(timeslot)
    print("\n")
