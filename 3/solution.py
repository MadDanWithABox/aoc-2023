import task_utils

def get_adjacent_digits(neighbour, visited, data):
    adjacent_digits = [["", 1], ["", 1]]
    
    #we can simplify here by using range(2) instead of checking for idx == 0  and idx == 1
    for idx in range(2):
        direction = -1 if idx == 0 else 1
        while (
            0 <= neighbour[0] + direction * adjacent_digits[idx][1] < len(data[neighbour[1]])
            and data[neighbour[1]][neighbour[0] + direction * adjacent_digits[idx][1]].isdigit()
            and (neighbour[0] + direction * adjacent_digits[idx][1], neighbour[1]) not in visited
        ):
            adjacent_digits[idx][0] += data[neighbour[1]][neighbour[0] + direction * adjacent_digits[idx][1]]
            visited.append((neighbour[0] + direction * adjacent_digits[idx][1], neighbour[1]))
            adjacent_digits[idx][1] += 1

    return adjacent_digits

def process_gear_adjacent(i, surroundings, part_1, gear_adjacent):
    if i == "*":
        gear_adjacent.append(surroundings)
    part_1 += surroundings
    return part_1

def main():
    # Init
    data = task_utils.import_rows()

    part_1 = 0
    part_2 = 0

    visited = []
    for y, row in enumerate(data):
        for x, i in enumerate(row):
            gear_adjacent = []
            if not i.isdigit() and i != ".":
                nextdoors = task_utils.get_neighbours(x=x, y=y, field=data, corners=True, as_tuple=True)
                for neighbour in nextdoors:
                    if data[neighbour[1]][neighbour[0]].isdigit() and (neighbour[0], neighbour[1]) not in visited:
                        visited.append((neighbour[0], neighbour[1]))
                        adjacent_digits = get_adjacent_digits(neighbour, visited, data)
                        surroundings = int(adjacent_digits[0][0][::-1] + data[neighbour[1]][neighbour[0]] + adjacent_digits[1][0])
                        part_1 = process_gear_adjacent(i, surroundings, part_1, gear_adjacent)

                if len(gear_adjacent) == 2:
                    part_2 += gear_adjacent[0] * gear_adjacent[1]

    print(part_1)
    print(part_2)

if __name__ == "__main__":
    main()
