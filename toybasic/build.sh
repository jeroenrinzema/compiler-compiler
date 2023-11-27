go run github.com/blynn/nex lexer.nex
go run golang.org/x/tools/cmd/goyacc -o basic.go parser_03.y
go build -o basic basic.go lexer.nn.go compiler.go