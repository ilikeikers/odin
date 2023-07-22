package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:unicode/utf8"

// Same string bug as Day02. Using Rune Arrays again.
get_rucksack_strings :: proc(filepath: string) -> (rucksacks: [dynamic][]rune) {
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
		// could not read file
		return
	}
	defer delete(data, context.allocator)

	it := string(data)
	for line in strings.split_lines_iterator(&it) {
        runes : []rune = utf8.string_to_runes(line)
        append(&rucksacks, runes)
	}

    return rucksacks
}

// 2022 Advent of Code Day 03
main :: proc() {

    filepath : string = "/home/ike/coding/odinpractice/adventOfCode2022/inputs/03.txt"
    test_rucksacks : [dynamic][]rune = get_rucksack_strings(filepath)

    // There is likely a better way to get these runes. Wasn't able to hunt it down in the docs though
    priority_runes := [52]rune{'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
                               'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
                               'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D',
                               'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
                               'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
                               'Y', 'Z'}

    priority_map := map[rune]int{}
    for item, index in priority_runes {
        priority : int = index + 1
        priority_map[item] = priority
    }

    item_priority : int = 0
    total_priority : int = 0
    badges : [dynamic]rune
    found_badge : bool
    for i := 0; i <= (len(test_rucksacks) - 3); i += 3 {
        found_badge = false
        rucksack_one := test_rucksacks[i]
        rucksack_two := test_rucksacks[i + 1]
        rucksack_three := test_rucksacks[i + 2]

        for three_rune in rucksack_three {
            for two_rune in rucksack_two {
                if two_rune == three_rune && !found_badge {
                    for one_rune in rucksack_one {
                        if one_rune == two_rune {
                            append(&badges, one_rune)
                            fmt.println(one_rune)
                            item_priority = priority_map[one_rune]
                            total_priority += item_priority
                            found_badge = true
                            break
                        }
                    }
                }
            }
        }
    }

    fmt.print("Badges: ")
    fmt.print(badges)
    fmt.print(len(badges))
    fmt.println()
    fmt.print("Sum of Priorities: ")
    fmt.print(total_priority)
    fmt.println()
}
