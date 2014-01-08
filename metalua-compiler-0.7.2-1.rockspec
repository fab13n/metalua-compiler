--*-lua-*--
package = "metalua-compiler"
version = "0.7.2-1"
source = {
   url = "git://github.com/fab13n/metalua-compiler",
   tag = "v0.7.2",
}

description = {
    summary = "Metalua's compiler: converting (Meta)lua source strings and files into executable Lua 5.1 bytecode",
   detailed = [[
           This is the Metalua copmiler, packaged as a rock, depending
           on the spearate metalua-parser AST generating library. It
           compiles a superset of Lua 5.1 into bytecode, which can
           then be loaded and executed by a Lua 5.1 VM. It also allows
           to dump ASTs back into Lua source files.
   ]],
   homepage = "http://git.eclipse.org/c/koneki/org.eclipse.koneki.metalua.git",
   license = "EPL + MIT"
}

dependencies = {
    "lua ~> 5.1",
    "checks >= 1.0",
    "metalua-parser == 0.7.2"
}



build = {
    type="builtin",
    modules={
        ["metalua.compiler.bytecode"] = "metalua/compiler/bytecode.lua",
        ["metalua.compiler.globals"] = "metalua/compiler/globals.lua",
        ["metalua.compiler.bytecode.compile"] = "metalua/compiler/bytecode/compile.lua",
        ["metalua.compiler.bytecode.lcode"] = "metalua/compiler/bytecode/lcode.lua",
        ["metalua.compiler.bytecode.lopcodes"] = "metalua/compiler/bytecode/lopcodes.lua",
        ["metalua.compiler.bytecode.ldump"] = "metalua/compiler/bytecode/ldump.lua",
        ["metalua.loader"] = "metalua/loader.lua",
    },
    install={lua={
        ["metalua.treequery"] = "metalua/treequery.mlua",
        ["metalua.compiler.ast_to_src"] = "metalua/compiler/ast_to_src.mlua",
        ["metalua.treequery.walk"] = "metalua/treequery/walk.mlua",
        ["metalua.extension.match"] = "metalua/extension/match.mlua",
        ["metalua.extension.xloop"] = "metalua/extension/xloop.mlua",
        ["metalua.extension.xmatch"] = "metalua/extension/xmatch.mlua",
        ["metalua.extension.comprehension"] = "metalua/extension/comprehension.mlua",
        ["metalua.extension.log"] = "metalua/extension/log.mlua",
        ["metalua.repl"] = "metalua/repl.mlua",
    }}
}

--[==[-- Generate file lists
for _, ext in ipairs{ 'lua', 'mlua' } do
    for filename in io.popen("find metalua -name '*."..ext.."'") :lines() do
        local modname = filename :gsub ('/', '.') :gsub ('%.'..ext..'$', '')
        print((' '):rep(8)..'["' .. modname .. '"] = "' ..  filename .. '",')
    end
    print""
end
--]==]--        ["metalua.bytecode"] = "metalua/bytecode.lua",
