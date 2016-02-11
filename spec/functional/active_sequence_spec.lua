local BehaviourTree = require 'lib/behaviour_tree'

describe('Active sequence', function()
  describe('with no child running', function()
    local subject, control, task1, task2, task3
    before_each(function()
      control = {}
      task1 = BehaviourTree.Task:new()
      task2 = BehaviourTree.Task:new()
      task3 = BehaviourTree.Task:new()
      subject = BehaviourTree.Sequence:new({
        control = control,
        nodes = {task1, task2, task3} 
      })
      subject:start()
    end)

    it('should call success on control if all nodes succeed', function()
      stub(control, 'success')
      function task1:run()
        self:success()
      end
      function task2:run()
        self:success()
      end
      function task3:run()
        self:success()
      end
      subject:run()
      assert.stub(control.success).was.called()
    end)
    it('should call fail if a single node fails', function()
      stub(control, 'fail')
      function task1:run()
        self:success()
      end
      function task2:run()
        self:fail()
      end
      function task3:run()
        self:success()
      end
      subject:run()
      assert.stub(control.fail).was.called()
    end)
    it('should stop at a failing node', function()
      stub(control, 'fail')
      stub(task2, 'fail')
      stub(task3, 'success')
      function task1:run()
        self:success()
      end
      function task2:run()
        self:fail()
      end
      function task3:run()
        self:success()
      end
      subject:run()
      assert.stub(task2.fail).was.called()
      assert.stub(task3.success).was_not.called()
    end)
  end)

  describe('with a child already running', function()
    local subject, control, task1, task2, task3
    before_each(function()
      control = { success = function() end,
      fail = function() end,
      running = function() end}

      task1 = BehaviourTree.Task:new()
      task2 = BehaviourTree.Task:new()
      task3 = BehaviourTree.Task:new()
      function task1:run()
        self:success()
      end
      function task2:run()
        self:running()
      end
      function task3:run()
        self:success()
      end

      subject = BehaviourTree.ActiveSequence:new({
        control = control,
        nodes = {task1, task2, task3} 
      })
      subject:start()
      subject:run()
    end)

    it('should still start from its first task when run', function()
      stub(task1, 'run')
      subject:run()
      assert.stub(task1.run).was.called()
    end)

    it('should stop the running child if a higher-priority child fails', function()
      function task1:run()
        self:fail()
      end
      stub(task2, 'finish')
      subject:run()
      assert.stub(task2.finish).was.called()
    end)

    it('should call control with fail if a higher-priority child fails', function()
      function task1:run()
        self:fail()
      end
      stub(control, 'fail')
      subject:run()
      assert.stub(control.fail).was.called()
    end)

    it('should stop the running child if a higher-priority child enters running', function()
      function task1:run()
        self:running()
      end
      stub(task2, 'finish')
      subject:run()
      assert.stub(task2.finish).was.called()
    end)

    it('should call control with running if a higher-priority child succeds', function()
      function task1:run()
        self:running()
      end
      stub(control, 'running')
      subject:run()
      assert.stub(control.running).was.called()
    end)

    it('should set self.runningTask = nil when all tasks succeed', function()
      function task2:run()
        self:success()
      end
      subject:run()
      assert.is_nil(subject.runningTask)
    end)
  end)
end)
