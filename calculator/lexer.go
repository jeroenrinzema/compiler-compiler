package main

import (
	"bufio"
	"errors"
	"fmt"
	"os"
	"unicode"
)

func main() {
	reader := bufio.NewReader(os.Stdin)
	yyErrorVerbose = true
	lex := lexer{
		vars: make(map[string]float64),
	}

	for {
		fmt.Print("> ")

		input, err := reader.ReadString('\n')
		if err != nil {
			fmt.Println("Bye.")
			return
		}

		lex.s = input
		lex.pos = 0
		lex.err = nil

		yyParse(&lex)
	}
}

const EOF = 0

type lexer struct {
	pos  int
	s    string
	err  error
	vars map[string]float64
}

func (l *lexer) Error(err string) {
	l.err = errors.New(err)
	fmt.Println(err)
}

func (l *lexer) Lex(lval *yySymType) int {
	var c = rune(l.s[l.pos])
	for unicode.IsSpace(c) {
		if l.pos == len(l.s) {
			return 0
		}
		c = rune(l.s[l.pos])
		l.pos += 1
	}

	switch {
	case isNumber(c):
		start := l.pos
		end := l.lookup(isNumber)
		lval.val = l.s[start:end]
		return NUMBER
	case unicode.IsLetter(c):
		start := l.pos
		end := l.lookup(unicode.IsLetter)
		lval.val = l.s[start:end]
		return IDENTIFIER
	}

	l.pos += 1
	lval.val = string(c)
	return int(c)
}

func (l *lexer) lookup(fn func(rune) bool) int {
	for l.pos < len(l.s) {
		c := rune(l.s[l.pos])
		if !fn(c) {
			return l.pos
		}
		l.pos += 1
	}

	return l.pos
}

func isNumber(r rune) bool {
	return unicode.IsDigit(r) || r == '.'
}
