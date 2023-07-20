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

// 2022 Advent of Code Day 01
// Find the Elf carrying the most Calories. How many total Calories is that Elf carrying?
main :: proc() {

    filepath : string = "/home/ike/coding/odinpractice/adventOfCode2022/inputs/01.txt"
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
