import sys

for line in sys.stdin:
    if "É" in line:
        continue
    if line.startswith("- "):
        line = line[2:]
    elif line.startswith("-"):
        line = line[1:]
    if any(bracket in line for bracket in "()[]"):
        continue
    if len(line) < 20:
        continue
    if sum(character.isascii() for character in line) / len(line) < 0.2:
        continue
    print(line, end="")
