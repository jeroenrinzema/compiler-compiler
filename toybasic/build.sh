go run github.com/blynn/nex lexer.nex
go run golang.org/x/tools/cmd/goyacc -o tiny.go parser.y
go build -o basic basic.go lexer.nn.go compiler.go