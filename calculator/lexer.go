package main

import (
	"bufio"
	"errors"
	"fmt"
	"os"
	"regexp"
	"strings"
)

func main() {
	reader := bufio.NewReader(os.Stdin)
	yyErrorVerbose = true
	interpreter := lexer{
		vars: make(map[string]float64),
	}

	for {
		fmt.Print("> ")

		input, err := reader.ReadString('\n')
		if err != nil {
			fmt.Println("Bye.")
			return
		}

		interpreter.input = input
		interpreter.err = nil

		yyParse(&interpreter)
	}
}

const EOF = 0

type lexer struct {
	input string
	err   error
	vars  map[string]float64
}

func (l *lexer) Error(err string) {
	l.err = errors.New(err)
	fmt.Println(err)
}

type tokenDef struct {
	regex *regexp.Regexp
	token int
}

var tokens = []tokenDef{
	{
		regex: regexp.MustCompile(`^[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?`),
		token: NUMBER,
	},
	{
		regex: regexp.MustCompile(`^[_a-zA-Z][_a-zA-Z0-9]*`),
		token: IDENTIFIER,
	},
}

func (l *lexer) Lex(lval *yySymType) int {
	l.input = strings.TrimLeft(l.input, " \t\n")

	if len(l.input) == 0 {
		return EOF
	}

	for _, def := range tokens {
		str := def.regex.FindString(l.input)
		if str != "" {
			// Pass string content to the parser.
			lval.String = str
			l.input = l.input[len(str):]
			return def.token
		}
	}

	// Otherwise return the next letter.
	ret := int(l.input[0])
	l.input = l.input[1:]
	return ret
}
