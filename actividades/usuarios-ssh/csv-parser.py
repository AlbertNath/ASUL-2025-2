import csv

reader = csv.reader(open("keys.csv", "r"))
for idx, row in enumerate(reader):
    if idx == 0:
        continue
    print("ROW START")
    for col in row:
        print(col)
        print()
