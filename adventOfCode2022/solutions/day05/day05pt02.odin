package main

import "core:fmt"
import "core:os"
import "core:runtime"
import "core:strconv"
import "core:strings"
import "core:math"
import "core:c/libc"
import "core:unicode/utf8"

instruction_type :: struct {amount: int, from: int, to: int}

parse_input :: proc(filepath: string) -> (stacks: map[int]string, instructions: #soa[dynamic]instruction_type) {
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
		// could not read file
		return
	}
	defer delete(data, context.allocator)

	it := string(data)
    line_number : int = 0
    instruction : bool = false
    instructions_index : int = 0
	for line in strings.split_lines_iterator(&it) {

        switch {

        case !instruction:
            // uses the crate names/numbers to break the list
            if line[1] == '1' {
                instruction = true
                break
            }

            runes_temp : [dynamic]rune
            strings_temp : [dynamic]string
            defer delete(runes_temp)
            defer delete(strings_temp)
            stack_key := 1
            // each bracket and space is counted. Jumping by 4 to only get runes
            for i := 1; i <= (len(line) - 1); i += 4 {
                character := utf8.rune_at(line, i)
                if character != ' ' {
                    // feel like there has to be a better way to concat a string. Not sure at the moment though
                    append_elem(&runes_temp, character)
                    temp_string := utf8.runes_to_string(runes_temp[:])
                    append_elem(&strings_temp, temp_string)
                    value := stacks[stack_key]
                    append_elem(&strings_temp, value)
                    value = strings.concatenate(strings_temp[:])
                    stacks[stack_key] = value
                }
                clear(&runes_temp)
                clear(&strings_temp)
                stack_key += 1
            }

        case instruction:
            update_instruction : instruction_type
            split_line := strings.split(line, " ")
            if len(split_line) > 1 {
                for i := 1; i <= len(split_line); i += 2 {
                    split_int : int = strconv.atoi(split_line[i])
                    if i == 1 {
                        update_instruction.amount = split_int
                    } else if i == 3 {
                        update_instruction.from = split_int
                    } else {
                        update_instruction.to = split_int
                    }
                }
                append_soa(&instructions, update_instruction)
            }
            instructions_index += 1
        }
        line_number += 1
	}

    return stacks, instructions
}

main :: proc() {
    filepath : string = "/home/ike/coding/odinpractice/adventOfCode2022/inputs/05.txt"

    stack_map, instruction_list := parse_input(filepath)

    strings_temp : [dynamic]string
    defer delete(strings_temp)
    for instruction, index in instruction_list {
        from_value := stack_map[instruction.from]
        to_value := stack_map[instruction.to]
        terminate : int = instruction.amount
        stack_map[instruction.from] = from_value[:(len(from_value) - terminate)]
        added_crate := from_value[(len(from_value) - terminate):]
        append_elem(&strings_temp, to_value)
        append_elem(&strings_temp, added_crate)
        to_value = strings.concatenate(strings_temp[:])
        stack_map[instruction.to] = to_value
        clear(&strings_temp)
    }

    temp_output : [dynamic]string
    stack_num : int = 1
    for key in stack_map {
        value := stack_map[stack_num]
        last_crate := value[len(value)-1:]
        append_elem(&temp_output, last_crate)
        stack_num += 1
    }
    output : string = strings.concatenate(temp_output[:])
    fmt.println("TOP CRATES: ")
    fmt.println(output)
}
