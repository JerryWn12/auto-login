import random

numbers = list(range(10000))

random.shuffle(numbers)

with open("numbers.txt", mode="a") as file:
    file.write("\n".join(str(f"{number:04d}") for number in numbers))
