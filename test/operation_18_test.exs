defmodule OperationEighteenTest do
  use ExUnit.Case

  test "operation 18-ret: jump to value popped from stack example one" do
    state = {0, [18, 21, 21, 0], [], [3]}
    {3, [18, 21, 21, 0], [], []} = VirtualMachine.ret(state)
  end

  test "operation 18-ret: jump to value popped from stack example two" do
    state = {1, [21, 18, 21, 21, 0], [], [3, 5]}
    {5, [21, 18, 21, 21, 0], [], [3]} = VirtualMachine.ret(state)
  end

end
