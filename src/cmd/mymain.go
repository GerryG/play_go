
package main

import (
  parser "ceptr/parser"
  token "ceptr/token"
)

func main() {
	fs := token.NewFileSet()
	pkgs, err := parser.ParseDir(fs, '.', func(i os.FileInfo) bool {return false}, parser.ParseComments)
}
