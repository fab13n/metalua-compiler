Metalua Complier
================

## Repository

`metalua-compiler` is temporarily hosted at github, while cutting
Metalua into finer-grained Luarock modules is in progress. However,
Metalua's official repository is at Eclipse, as part of the
[koneki](http://www.eclipse.org/koneki/) project; Luarocks will
eventually migrate there once stabilized. A miror on github will be
maintained for easier code sharing, though.

## Metalua compiler

This moodule depends on `metalua-parser`. Its main feature is to
compile ASTs into Lua 5.1 bytecode, allowing to convert them into
bytecode files and executable functions. This opens the following
possibilities:

* compiler objects generated with `require 'metalua.compiler'.new()`
  support methods `:xxx_to_function()` and `:xxx_to_bytecode()`;

* Compile-time meta-programming: use of `-{...}` splices in source
  code, to generate code during compilation;

* Some syntax extensions, such as structural pattern matching and
  lists by comprehension;

* Some AST manipulation facilities such as `treequery`, which are
  implemented with Metalua syntax extensions.
