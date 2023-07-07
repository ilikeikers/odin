package main

// The package name defaults to the last element
import "core:fmt" // Name is fmt
import foo "core:os" // Name is foo

main :: proc() {
    fmt.println("Hello from Odin")
}

// A comment

my_integer_variable: int // A comment for documentation

/* A Multiline Comment
    /*
        A Nested Multiline comment!
    */
*/

string_example:= "This is a string!"
character_example:= 'A'
other_char_example:= '\n'

/*
Escape Characters:
https://odin-lang.org/docs/overview/#escape-characters
*/
// Special characters are escaped with backslash
path_example:= "C:\\Windows\\notepad.exe"
// Raw String Literals are enclosed in backticks
other_path_example:= `C:\Windows\notepad.exe`

// Numbers can be arbitrarily separated with _ for readability
// Numbers with . are floats (1.0e9 is one billion)
// Numbers suffixed with i are imaginary (2i)
// Binary Literal Prefix: 0b
// Octal Literal Prefix: 0o
// Hex Literal Prefix: 0x
// Variables initialized to zero by default

x: int
x, z: int
x: int = 123
x = 637
// Numbers can automatically switch type if no data is lost
x: int = 1.0 // Float that can be represented as int without data loss
// Constant literals are untyped and can implicity convert to a type
x = 1 // Untyped int literal. Implicitly converted to int type

x, y := 1, "hello" // Can assign multiple vars with types inferred
y, x = "bye", 5

// The following are all equivalent:
x: int = 123
x:     = 123
x := 123

// Constants cannot be  changed
x :: "what"
y : int : 123
z :: y + 7 // Constant computations are possible

// All declarations are exported by default
// Private attribute applied to prevent export
@(private) // Same as '@(private="package")'
my_private_int: int // Cannot be accessed outside this package

@(private="file")
my_private_file_int: int // Cannot be accessed outside this file

// For Statement is the only loop
/*
Components:
    initial statement (optional) ;
    condition expression ;
    post statement (optional) ;
*/
for_loop_examples :: proc() {
    // Will stop when condition is evaluated to false
    // Basic
    for i := 0; i < 10; i += 1 {
        fmt.println(i)
    }
    // Exclusive Upper Limit
    for i in 0..<10 {
        fmt.println(i)
    }
    // Inclusive Upper Limit
    for i in 0..=9 {
        fmt.println(i)
    }

    // Braces or 'do' are always required
    for i := 0; i < 10; i += 1 {}
    for i := 0; i < 10; i += 1 do fmt.println(i)

    i := 0
    for ; i < 10; {
        i += 1
    }

    // Infinite Loop
    /*
    for {
    }
    */
}

type_loop_examples :: proc() {
    // Iterated values are COPIES and connot be written to
    for character in some_string {
        fmt.println(character)
    }
    for value in some_array {
        fmt.println(value)
    }
    for value in some_slice {
        fmt.println(value)
    }
    for value in some_dynamic_array {
        fmt.println(value)
    }
    for value in some_map {
        fmt.println(value)
    }
    // Can also get the index
    for character, index in some_string {
        fmt.println(character)
    }
    for value, index in some_array {
        fmt.println(value)
    }
    for value, index in some_slice {
        fmt.println(value)
    }
    for value, index in some_dynamic_array {
        fmt.println(value)
    }
    for value, index in some_map {
        fmt.println(value)
    }
    // Idiom for iterating over a container in a by-reference manner
    for _, i in some_slice {
        some_slice[i] = something
    }
}

if_examples :: proc() {
    // if statements don't need parentheses
    // Braces or do are required
    if x >= 0 {
        fmt.println("x is positive")
    }
    // Can use initial statements
    // Like a for loop, they only exist in the scope of the if statement
    if x := foo(); x < 0 {
        fmt.println("x is negative")
    // Also available to the else blocks
    } else if x == 0 {
        fmt.println("x is zero")
    } else {
        fmt.println("x is positive")
    }
}

// Switch Statements are another way to write a sequence of if-else statements
// Default case is denoted as a case without any expression
// Only runs the selected case, so no 'break' statement is required
// Case values don't need to be integers nor constants
// The keyword 'fallthrough' can be used for a C-like fall through into the next case block
// Evaluated top to bottom. Stop when a case succeeds
// If all the case values are constants, the compiler may optimize the switch statment into a jump table
switch_example :: proc(arch) {
    switch arch := ODIN_ARCH; arch {
    case .i386, .wasm32:
        fmt.println("32 bit")
    case .amd64, .wasm64, .arm64:
        fmt.println("64 bit")
    case .Unknown:
        fmt.println("Unknown Architecture")
    }
}
// Below, foo() does not get called if i==0
switch_stop_example :: proc(i) {
    switch i {
    case 0:
    case foo():
    }
}
// Below, foo() does not get called if i==0
switch_stop_example :: proc(i) {
    switch i {
    case 0:
    case foo():
    }
}
// If no condition is given, it is the same as 'swith true'
// Useful for a long 'if-else' chain
// Can 'break' if needed as well
switch_true_example :: proc(x) {
    switch  {
    case x < 0:
        fmt.println("x is negative")
    case x == 0:
        fmt.println("x is zero")
    case:
        fmt.println("x is positive")
    }
}
// Can also use ranges
switch_range_examples :: proc(c, x) {
    switch c {
    case 'A'..'Z', 'a'..'z', '0'..'9':
        fmt.println("c is alphanumeric")
    }

    switch  x {
    case 0..<10:
        fmt.println("units")
    case 10..<13:
        fmt.println("pre-teens")
    case 13..<20:
        fmt.println("teens")
    case 20..<30:
        fmt.println("twenties")
    }
}

// Partial Switich

Foo :: enum {
	A,
	B,
	C,
	D,
}

f := Foo.A
switch f {
case .A: fmt.println("A")
case .B: fmt.println("B")
case .C: fmt.println("C")
case .D: fmt.println("D")
case:    fmt.println("?")
}

#partial switch f {
case .A: fmt.println("A")
case .D: fmt.println("D")
}
