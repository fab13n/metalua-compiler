-------------------------------------------------------------------------------
-- Copyright (c) 2006-2014 Fabien Fleutot and others.
--
-- All rights reserved.
--
-- This program and the accompanying materials are made available
-- under the terms of the Eclipse Public License v1.0 which
-- accompanies this distribution, and is available at
-- http://www.eclipse.org/legal/epl-v10.html
--
-- This program and the accompanying materials are also made available
-- under the terms of the MIT public license which accompanies this
-- distribution, and is available at http://www.lua.org/license.html
--
-- Contributors:
--     Fabien Fleutot - API and implementation
--
-------------------------------------------------------------------------------

--
-- Example of treequery usage: list all the unauthorized global
-- variable occurrences in a given source file.
--
-- Usage: lua globals.lua file_to_analyze.lua
--
-- TODO:
-- * take command-line options
-- * 

require 'metalua.loader' -- needed to load "metalua/treequery.mlua"

mlc     = require 'metalua.compiler'.new() -- compiler
Q       = require 'metalua.treequery'      -- AST queries
pp      = require 'metalua.pprint'         -- pretty-printer
srcfile = ...                              -- filename to analyze...
ast     = mlc :srcfile_to_ast(srcfile)     -- ...converted in an AST

-- Global variable names which won't be reported:
allowed = [[_G _VERSION assert collectgarbage coroutine debug dofile
error gcinfo getfenv getmetatable io ipairs load loadfile loadstring
math module newproxy next os package pairs pcall print rawequal rawget
rawset require select setfenv setmetatable string table tonumber
tostring type unpack xpcall]]

-- The same, put in a hash-table for easy retrieval:
allowed_set = { }
for word in allowed :gmatch "%S+" do allowed_set[word]=true end

function analyze(ast)
    local globals = { } -- variable name -> list of line numbers

    -- add the line number where node `id` occurs into table `globals`:
    local function log_global(id, ...)
        local name = id[1]
        local line = id.lineinfo and id.lineinfo.first.line or "no info"
        local full_chain = {[0]=id, ...}
        -- Retrieve the subfields x.subfield_1.....subfield_n
        for i, ancestor in ipairs(full_chain) do
            -- `Index{ x, `String y } if x==full_chain[i-1]
            if ancestor.tag=='Index' and
                ancestor[1]==full_chain[i-1] and
                ancestor[2].tag=='String' then
                name = name.."."..ancestor[2][1]
            else break end
        end
        local lines = globals[name]
        if lines then table.insert(lines, line)
        else globals[name] = { line } end
    end

    -- Treequery command to retrieve global variable occurrences:
    Q(ast)                         -- globals are...
        :filter 'Id'               -- ...nodes with tag 'Id'...
        :filter_not (Q.is_binder)  -- ...which are not local binders...
        :filter_not (Q.get_binder) -- ...and aren't bound;
        :foreach (log_global)      -- log each of them in `globals`.

    -- format and sort the result
    local sort_them = { }
    for name, lines in pairs(globals) do
        if not allowed_set[name] then
            local line = name .. ": " .. pp.tostring(lines) :sub (2, -2)
            table.insert(sort_them, line)
        end
    end

    -- print the result
    if next(sort_them) then
        table.sort(sort_them)
        print(table.concat(sort_them, "\n"))
    else print "no global found" end
end

analyze(ast)