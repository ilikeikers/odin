package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:unicode/utf8"


// Same string bug as Day02. Using Rune Arrays again.
get_string :: proc(filepath: string) -> (input_string: [dynamic][]rune) {
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
		// could not read file
		return
	}
	defer delete(data, context.allocator)

	it := string(data)
	for line in strings.split_lines_iterator(&it) {
        runes : []rune = utf8.string_to_runes(line)
        append(&input_string, runes)
	}

    return input_string
}

main :: proc() {

    filepath : string = "/home/ike/coding/odinpractice/adventOfCode2022/inputs/06.txt"
    datastream : [dynamic][]rune = get_string(filepath)

    found_marker : int
    for item in datastream {
        marker_index : int
        for i := 0; i <= (len(item) - 4); i += 1 {
            marker_index = i + 4
            if (item[i+2] != item[i+3]) {
                if (item[i+1] != item[i+2]) && (item[i+1] != item[i+3]) {
                    if (item[i] != item[i+1]) && (item[i] != item[i+2]) && (item[i] != item[i+3]) {
                        found_marker = marker_index
                        break
                    }
                }
            }
        }
    }

    fmt.println("MARKER AT: ")
    fmt.println(found_marker)
}
