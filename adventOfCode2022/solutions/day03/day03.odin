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

    shared : bool = false
    tested : bool = false
    item_priority : int = 0
    total_priority : int = 0
    rucksack_divide : int = 0
    shared_items : [dynamic]rune
    tested_items : [dynamic]rune
    compartment_one : []rune
    compartment_two : []rune
    for rucksack in test_rucksacks {
        shared = false
        tested_items = {}
        rucksack_divide = len(rucksack) / 2
        compartment_one = rucksack[0:rucksack_divide]
        compartment_two = rucksack[rucksack_divide:]
        for item_rune in compartment_two {
            tested = false
            for item in compartment_one {
                if item == item_rune {
                    shared = true
                } else {
                    continue
                }
            }
            for item in tested_items {
                if !tested {
                    tested = (item == item_rune)
                } else {
                    continue
                }
            }
            if shared && !tested {
                append(&shared_items, item_rune)
                item_priority = priority_map[item_rune]
                total_priority += item_priority
                break
            }
            append(&tested_items, item_rune)
        }
    }

    fmt.print("Shared Items: ")
    fmt.print(shared_items)
    fmt.println()
    fmt.print("Sum of Priorities: ")
    fmt.print(total_priority)
    fmt.println()
}
