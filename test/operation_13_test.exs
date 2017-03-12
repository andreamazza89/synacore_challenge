defmodule OperationThireenTest do
  use ExUnit.Case

  test "operation 13-or: set register at 1st parameter to bitwise or of value of 1st and of 2nd" do
    state = {0, [12, 32768, 55, 42, 0], [0, 0, 0, 0, 0, 0, 0, 0], []}
    {4, [12, 32768, 55, 42, 0], new_registers, []} = VirtualMachine.bitwise_or(state)
    assert new_registers == [63, 0, 0, 0, 0, 0, 0, 0]
  end

  test "operation 13-or: set register at 1st parameter to bitwise or of value at 1st and at 2nd" do
    state = {1, [21, 12, 32768, 32770, 32771, 0], [0, 0, 42, 42, 0, 0, 0, 0], []}
    {5, [21, 12, 32768, 32770, 32771, 0], new_registers, []} = VirtualMachine.bitwise_or(state)
    assert new_registers == [42, 0, 42, 42, 0, 0, 0, 0]
  end

end
