package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:runtime"
import "core:strconv/decimal"
import "core:unicode/utf8"


/* I had orginally organized this as strings/slices. However, a weird bug popped up. When passing the arrays to the main function,
the first 5-6 items would return null unicode. Even though it was reading correctly in the get_strategy_input proc.
I'm not smart enough or experienced enough in Odin to figure it out. Went with Rune Arrays instead.
*/

get_strategy_input :: proc(filepath: string) -> (opponent_plays: [dynamic][]rune, self_plays: [dynamic][]rune) {
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
		// could not read file
		return
	}
	defer delete(data, context.allocator)

	it := string(data)
    // index not working in for loop. Doing manually
    index : int = 0
	for line in strings.split_lines_iterator(&it) {
        opponent_play_string : string  = line[:1]
        self_play_string : string = line[2:]
        opponent_play : []rune = utf8.string_to_runes(opponent_play_string)
        self_play : []rune = utf8.string_to_runes(self_play_string)
        assign_at_elem(&opponent_plays, index, opponent_play)
        assign_at_elem(&self_plays, index, self_play)
        index += 1
	}

    return opponent_plays, self_plays
}

// 2022 Advent of Code Day 02
main :: proc() {

    filepath : string = "/home/ike/coding/odinpractice/adventOfCode2022/inputs/02.txt"

    opponent_strategy, self_strategy : [dynamic][]rune
    clear(&opponent_strategy)
    clear(&self_strategy)
    opponent_strategy, self_strategy = get_strategy_input(filepath)
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
    total_score : int = 0
    for opponent_play_array, index in opponent_strategy {
        opponent_play : string = utf8.runes_to_string(opponent_play_array)
        round_score : int = 0
        suggested_play_array : []rune = self_strategy[index]
        suggested_play : string = utf8.runes_to_string(suggested_play_array)
        combined_play := [2]string{opponent_play, suggested_play}
        outcome_key := strings.concatenate(combined_play[:])
        potential_play_score : int = play_score[suggested_play]
        potential_outcome_score : int = outcome_score[outcome_key]
        round_score = potential_play_score + potential_outcome_score
        total_score += round_score
        defer delete(opponent_play)
        defer delete(suggested_play)
        defer delete(suggested_play_array)
        defer delete(outcome_key)
    }
    defer delete(opponent_strategy)
    defer delete(self_strategy)
    defer delete(play_score)
    defer delete(outcome_score)

    fmt.println("TOTAL SCORE: ")
    fmt.println(total_score)

}
