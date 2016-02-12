package = "behaviourtree"
version = "1.0-0"
source = {
  url = "git://github.com/odavison/behaviourtree.lua",
  branch = "master"
}
description = {
  summary = "A behaviour tree for lua",
  detailed = [[
    A behaviour tree implementation for lua, including 
    the basic BT node types.
  ]],
  homepage = "",
  license = "MIT <http://opensource.org/licenses/MIT>"
}
dependencies = {
  "lua >= 5.1",
}
build = {
  type = "builtin",
  modules = {
    ["bt"] = "lib/init.lua",
    ["bt.BehaviourTree"] = "lib/behaviour_tree.lua",
    ["bt.Registry"] = "lib/registry.lua",
    ["bt.middleclass"] = "lib/middleclass.lua",
    ["bt.node_types.always_fail_decorator"] = "lib/node_types/always_fail_decorator.lua",
    ["bt.node_types.always_succeed_decorator"] = "lib/node_types/always_succeed_decorator.lua",
    ["bt.node_types.branch_node"] = "lib/node_types/branch_node.lua",
    ["bt.node_types.decorator"] = "lib/node_types/decorator.lua",
    ["bt.node_types.invert_decorator"] = "lib/node_types/invert_decorator.lua",
    ["bt.node_types.node"] = "lib/node_types/node.lua",
    ["bt.node_types.priority"] = "lib/node_types/priority.lua",
    ["bt.node_types.random"] = "lib/node_types/random.lua",
    ["bt.node_types.sequence"] = "lib/node_types/sequence.lua",
  }
}
