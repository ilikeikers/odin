package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:runtime"
import "core:strconv/decimal"


get_calorie_list :: proc(filepath: string) -> (calories_list: [dynamic]u64) {
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
		// could not read file
		return
	}
	defer delete(data, context.allocator)

	it := string(data)
	for line in strings.split_lines_iterator(&it) {
        d: decimal.Decimal
        decimal.set(&d, line)
        calories : u64 = decimal.rounded_integer(&d)
        runtime.append_elem(&calories_list, calories)
	}


    return calories_list
}

update_list :: proc(input_list: [dynamic]u64, calories: u64) -> (updated_list : [dynamic]u64, lowest_item : u64) {

    lowest_item = input_list[0]
    low_index : int = 0
    updated_list = input_list

    for item, index in input_list {
        if item < lowest_item {
            low_index = index
            lowest_item = item
        }
    }

    unordered_remove(&updated_list, low_index)
    append(&updated_list, calories)

   return updated_list, lowest_item
}

// 2022 Advent of Code Day 01
// Find the Elf carrying the most Calories. How many total Calories is that Elf carrying?
main :: proc() {

    filepath : string = "/home/ike/coding/odinpractice/adventOfCode2022/inputs/01.txt"

    top_three_elves := [dynamic]u64{0, 0, 0}
    min_calories : u64 = 0
    total_calories : u64 = 0

    elf_calories : [dynamic]u64
    elf_calories = get_calorie_list(filepath)
    defer delete(elf_calories)

    elf_number : int = 1
    biggest_elf : int = 0
    calorie_count : u64 = 0
    biggest_bag : u64 = 0

    for calories in elf_calories {
        switch {
        case calories == 0:
            if calorie_count > min_calories {
                top_three_elves, min_calories = update_list(top_three_elves, calorie_count)
                biggest_elf = elf_number
                biggest_bag = calorie_count
            }
            elf_number += 1
            calorie_count = 0
        case:
            calorie_count += calories
        }
    }

    for item in top_three_elves {
        total_calories += item
    }

    fmt.println("Top Three Elf Calories: ")
    fmt.println(total_calories)
}
