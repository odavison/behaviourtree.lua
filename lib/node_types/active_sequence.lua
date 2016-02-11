local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]?node_types", "")
local class = require(_PACKAGE..'/middleclass')
local Registry = require(_PACKAGE..'/registry')
local Sequence  = require(_PACKAGE..'/node_types/sequence')
local ActiveSequence = class('ActiveSequence', Sequence)

function ActiveSequence:success()
  if self.runningTask == self.actualTask then
    self.runningTask = nil
  end
  Sequence.success(self)
end

function ActiveSequence:fail()
  self:_finishRunningNode()
  self.runningTask = nil
  Sequence.fail(self)
end

function ActiveSequence:running()
  self:_finishRunningNode()
  self.runningTask = self.actualTask
  self.control:running()
  self.actualTask = 1
end

function ActiveSequence:_finishRunningNode()
  if self.runningTask and self.runningTask > self.actualTask then
    local runningNode = Registry.getNode(self.nodes[self.runningTask]) 
    runningNode:finish()
  end
end

return ActiveSequence
