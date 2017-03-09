defmodule OperationTwoTest do
  use ExUnit.Case

  test "operation 2-push: push value of 1st parameter into stack" do
    state = {0, [2, 66, 0], [], [42]};
    {2, [2, 66, 0], [], new_stack} = VirtualMachine.push_into_stack(state)
    assert new_stack == [42, 66]
  end

  test "operation 2-push: push value at 1st parameter into stack" do
    state = {1, [21, 2, 32768, 0], [34, 0, 0, 0, 0, 0, 0, 0], [42, 666]};
    {3, [21, 2, 32768, 0], [34, 0, 0, 0, 0, 0, 0, 0], new_stack} = VirtualMachine.push_into_stack(state)
    assert new_stack == [42, 666, 34]
  end

end
