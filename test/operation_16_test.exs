defmodule OperationSixteenTest do
  use ExUnit.Case

  test "operation 16-wmem: set memory of 1st parameter to register at 2nd parameter" do
    state = {0, [16, 3, 32768, 42, 0], [7, 0, 0, 0, 0, 0, 0, 0], []}
    {3, new_memory, [7, 0, 0, 0, 0, 0, 0, 0], []} = VirtualMachine.wmem(state)
    assert [16, 3, 32768, 7, 0] == new_memory
  end

  test "operation 16-wmem: set memory of 1st parameter to register of 2nd parameter" do
    state = {1, [21, 16, 4, 9, 42, 0], [7, 0, 0, 0, 0, 0, 0, 0], []}
    {4, new_memory, [7, 0, 0, 0, 0, 0, 0, 0], []} = VirtualMachine.wmem(state)
    assert [21, 16, 4, 9, 9, 0] == new_memory
  end

end
