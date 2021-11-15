import sys

for line in sys.stdin:
    if "É" in line:  # Probably an encoding artifact
        continue
    if line.startswith("- "):
        line = line[2:]
    elif line.startswith("-"):
        line = line[1:]
    if any(bracket in line for bracket in "()[]"):  # Non-speech comments
        continue
    if len(line) < 20:  # Too short
        continue
    if sum(character.isascii() for character in line) / len(line) < 0.2:  # Noise
        continue
    print(line, end="")
