package main

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strings"
import "core:c/libc"
import "core:unicode/utf8"


// Same string bug as seen earlier
get_ranges :: proc(filepath: string) -> (range_one: [dynamic][]rune, range_two: [dynamic][]rune) {
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
		// could not read file
		return
	}
	defer delete(data, context.allocator)

    split_line : []string
    index: int = 0
	it := string(data)
	for line in strings.split_lines_iterator(&it) {
        split_line = strings.split(line, ",")
        split_one_string := split_line[0]
        split_two_string := split_line[1]
        split_one : []rune = utf8.string_to_runes(split_one_string)
        split_two : []rune = utf8.string_to_runes(split_two_string)
        assign_at_elem(&range_one, index, split_one)
        assign_at_elem(&range_two, index, split_two)
        index += 1
	}

    return range_one, range_two
}

get_bounds :: proc(bounds: []string ) -> (upper_bound: i32, lower_bound: i32) {
    lower_cstring : cstring = strings.clone_to_cstring(bounds[0])
    upper_cstring : cstring = strings.clone_to_cstring(bounds[1])
    defer delete(lower_cstring)
    defer delete(upper_cstring)
    lower_bound = libc.atoi(lower_cstring)
    upper_bound = libc.atoi(upper_cstring)

    return lower_bound, upper_bound
}

// 2022 Advent of Code Day 03
main :: proc() {

    filepath : string = "/home/ike/coding/odinpractice/adventOfCode2022/inputs/04.txt"
    range_one_runes, range_two_runes : [dynamic][]rune = get_ranges(filepath)

    range_one : [dynamic]string
    index := 0
    for range in range_one_runes {
        range_string := utf8.runes_to_string(range)
        assign_at_elem(&range_one, index, range_string)
        index += 1
    }

    range_two : [dynamic]string
    index = 0
    for range in range_two_runes {
        range_string := utf8.runes_to_string(range)
        assign_at_elem(&range_two, index, range_string)
        index += 1
    }

    overlap_count : int = 0
    for section_pairs_one, i in range_one {
        bounds_one := strings.split(section_pairs_one, "-")
        section_pairs_two : string = range_two[i]
        bounds_two := strings.split(section_pairs_two, "-")
        lower_bound_one, upper_bound_one : i32 = get_bounds(bounds_one)
        lower_bound_two, upper_bound_two : i32 = get_bounds(bounds_two)
        lower_test_one : bool = lower_bound_one < upper_bound_two
        lower_test_two : bool = lower_bound_one > upper_bound_two
        upper_test_one : bool = upper_bound_one < lower_bound_two
        upper_test_two : bool = upper_bound_one > lower_bound_two
        test_one : bool = (lower_test_one) & (upper_test_one)
        test_two : bool = (lower_test_two) & (upper_test_two)
        no_overlap : bool = test_one | test_two
        // should reorganize logic above to avoid a double negative
        overlaps : bool = !no_overlap
        if overlaps {
            overlap_count += 1
        }
    }
        fmt.print("The Number of Overlaping Assignments is: ")
        fmt.print(overlap_count)
        fmt.println()
}
