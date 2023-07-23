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

    found_marker : int = 0
    for item in datastream {
        marker_index : int
        for i := 0; i <= (len(item) - 14); i += 1 {
            potential_string : string = utf8.runes_to_string(item[ i : i+13 ])
            marker_index = i + 14
            if found_marker == 0 {
                for offset := 1; offset <= 14; offset += 1 {
                    repeated_character : bool = false
                    test_string : string = utf8.runes_to_string(item[ i : i+offset ])
                    new_potential_string : string = potential_string[ offset : ]
                    repeated_character = strings.contains_any(new_potential_string, test_string)
                    if repeated_character {
                       break
                    }
                    if (offset == 13) && !repeated_character {
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
