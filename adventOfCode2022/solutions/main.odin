package main

import "core:fmt"
import "core:runtime"
import "core:strings"
import "core:math"
import "core:c/libc"
// 2022 Advent of Code Day 01
// Find the Elf carrying the most Calories. How many total Calories is that Elf carrying?

day_01 :: proc() {

    elf_calories := [dynamic]int{1000, 2000, 3000, 0, 4000, 0, 5000, 6000, 0, 7000, 8000, 9000, 0, 10000}
    elf_number : int = 1
    biggest_elf : int = 0
    calorie_count : int = 0
    biggest_bag : int = 0
    defer delete(elf_calories)
    for calories in elf_calories {
        switch {
        case calories == 0:
            elf_number += 1
            calorie_count = 0
        case:
            calorie_count += calories
        }
        if calorie_count > biggest_bag {
            biggest_elf = elf_number
            biggest_bag = calorie_count
        }
    }
    fmt.println("Elf to ask: ")
    fmt.println(biggest_elf)
    fmt.println("His Calories: ")
    fmt.println(biggest_bag)
}

day_02 :: proc() {

    test_guide := map[string]string{"A" = "Y", "B" = "X", "C" = "Z"}
    play_score := map[string]int{"X" = 1, "Y" = 2, "Z" = 3}
    outcome_score := map[string]int{"AX" = 3,
                                  "AY" = 6,
                                  "AZ" = 0,
                                  "BX" = 0,
                                  "BY" = 3,
                                  "BZ" = 6,
                                  "CX" = 6,
                                  "CY" = 0,
                                  "CZ" = 3}
    //defer delete(test_guide)
    //defer delete(outcomes)
    total_score : int = 0
    for opponent_play in test_guide {
        round_score : int = 0
        suggested_play : string = test_guide[opponent_play]
        combined_play := [2]string { opponent_play, suggested_play }
        outcome_key := strings.concatenate(combined_play[:])
        potential_play_score : int = play_score[suggested_play]
        potential_outcome_score : int = outcome_score[outcome_key]
        round_score = potential_play_score + potential_outcome_score
        fmt.println(round_score)
        total_score += round_score
    fmt.println(total_score)
    }
}

day_03 :: proc() {

    priority_map := map[rune]int{}
    priority_runes := [52]rune{'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
                               'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
                               'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D',
                               'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
                               'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
                               'Y', 'Z'}
    test_rucksacks := [?]string{"vJrwpWtwJgWrhcsFMMfFFhFp",
                                "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL",
                                "PmmdzqPrVvPwwTWBwg",
                                "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn",
                                "ttgJtRGJQctTZtZT",
                                "CrZsJsPPZsGzwwsLwLmpwMDw"}
    for item, index in priority_runes {
        priority : int = index + 1
        priority_map[item] = priority
    }
    shared : bool = false
    tested : bool = false
    shared_items := [dynamic]rune{}
    tested_items := [dynamic]rune{}
    item_priority : int = 0
    total_priority : int = 0
    rucksack_divide : int = 0
    compartment_one : string = ""
    compartment_two : string = ""
    for rucksack in test_rucksacks {
        shared = false
        tested_items = {}
        rucksack_divide = len(rucksack) / 2
        compartment_one = rucksack[0:rucksack_divide]
        compartment_two = rucksack[rucksack_divide:]
        for item_rune in compartment_two {
            tested = false
            shared = strings.contains_rune(compartment_one, item_rune)
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

day_04 :: proc() {

    test_pairs := map[string]string { "2-4"="6-8", "2-3"="4-5", "5-7"="7-9", "2-8"="3-7", "6-6"="4-6", "2-6"="4-8"}

    get_bounds :: proc(bounds: []string ) -> (upper_bound: i32, lower_bound: i32) {
        lower_cstring : cstring = strings.clone_to_cstring(bounds[0])
        upper_cstring : cstring = strings.clone_to_cstring(bounds[1])
        defer delete(lower_cstring)
        defer delete(upper_cstring)
        lower_bound = libc.atoi(lower_cstring)
        upper_bound = libc.atoi(upper_cstring)

        return lower_bound, upper_bound
    }

    fully_contained_count : int = 0
    for section_pairs_one in test_pairs {
        bounds_one := strings.split(section_pairs_one, "-")
        section_pairs_two : string = test_pairs[section_pairs_one]
        bounds_two := strings.split(section_pairs_two, "-")
        lower_bound_one, upper_bound_one : i32 = get_bounds(bounds_one)
        lower_bound_two, upper_bound_two : i32 = get_bounds(bounds_two)
        lower_test_one : i32 = lower_bound_two - lower_bound_one
        lower_test_two : i32 = lower_bound_one - lower_bound_two
        upper_test_one : i32 = upper_bound_one - upper_bound_two
        upper_test_two : i32 = upper_bound_two - upper_bound_one
        test_one : bool = (lower_test_one >= 0) && (upper_test_one >= 0)
        test_two : bool = (lower_test_two >= 0) && (upper_test_two >= 0)
        fully_contained : bool = test_one | test_two
        if fully_contained {
            fully_contained_count += 1
        }
    }
        fmt.print("The Number of Fully Contained Assignments is: ")
        fmt.print(fully_contained_count)
        fmt.println()
}

day_05 :: proc() {

    test_array_one := [dynamic]rune{'Z', 'N'}
    test_array_two := [dynamic]rune{'M', 'C', 'D'}
    test_array_three := [dynamic]rune{'P'}

    // Might not end up using
    row_names := map[i32][dynamic]rune { 1 = test_array_one, 2 = test_array_two, 3 = test_array_three }

    test_instruction_set := [dynamic]string{ "move 1 from 2 to 1",
                                             "move 3 from 1 to 3",
                                             "move 2 from 2 to 1",
                                             "move 1 from 1 to 2"}

    get_int :: proc(parsed_instruction: string ) -> (parsed_int: i32) {

        parsed_cstring : cstring = strings.clone_to_cstring(parsed_instruction)
        defer delete(parsed_cstring)
        parsed_int = libc.atoi(parsed_cstring)

        return parsed_int
    }

    instruction_parser :: proc(instruction: string) -> (number_of_crates: i32, pull_row: i32, add_row: i32) {

        // front_half holds the number_of_crates
        // back_half holds the row information
        halves := strings.split(instruction, " from ")
        front_half := strings.split(halves[0], " ")
        back_half := strings.split(halves[1], " ")
        number_of_crates = get_int(front_half[1])
        pull_row = get_int(back_half[0])
        add_row = get_int(back_half[2])

        return number_of_crates, pull_row, add_row
    }

    for instruction in test_instruction_set {

        number_of_crates, pull_row_key, add_row_key := instruction_parser(instruction)
        pull_row := row_names[pull_row_key]
        add_row := row_names[add_row_key]
        row_length := i32(len(pull_row))
        number_of_crates = number_of_crates
        starting_index := row_length - number_of_crates
        new_pull_row := [dynamic]pull_row[ 0 : starting_index ]
        crates_to_add := pull_row[ starting_index : ]
        append(&add_row, ..crates_to_add)
        row_names[ pull_row_key ] = new_pull_row
        row_names[ add_row_key ] = add_row
    }
        //row_names[pull_row_key] = new_pull_row
        //row_names[add_row_key] = add_row

    fmt.println(row_names[1])
    fmt.println(row_names[2])
    fmt.println(row_names[3])
}


main :: proc() {

    when true {
        //day_01()
        //day_02()
        //day_03()
        //day_04()
        day_05()
    }
}
