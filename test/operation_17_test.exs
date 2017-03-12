defmodule OperationSeventeenTest do
  use ExUnit.Case

  test "operation 17-call: write address of next instruction to stack and jump to cursor of 1st parameter" do
    state = {0, [17, 3, 10, 0], [], [42]}
    {3, [17, 3, 10, 0], [], new_stack} = VirtualMachine.call(state)
    assert new_stack == [42, 2]
  end

  test "operation 17-call: write address of next instruction to stack and jump to cursor at 1st parameter" do
    state = {1, [21, 17, 32768, 10, 0], [55, 0, 0, 0, 0, 0, 0, 0], [42, 2]}
    {55, [21, 17, 32768, 10, 0], [55, 0, 0, 0, 0, 0, 0, 0], new_stack} = VirtualMachine.call(state)
    assert new_stack == [42, 2, 3]
  end

end
