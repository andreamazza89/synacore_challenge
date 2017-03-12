defmodule OperationFourteenTest do
  use ExUnit.Case

  test "operation 14-not: set register at 1st parameter to bitwise not of value of 1st patameter" do
    state = {0, [14, 32768, 10, 0], [0, 0, 0, 0, 0, 0, 0, 0], []}
    {3, [14, 32768, 10, 0], new_registers, []} = VirtualMachine.bitwise_not(state)
    assert new_registers == [32757, 0, 0, 0, 0, 0, 0, 0]
  end

  test "operation 14-not: set register at 1st parameter to bitwise not of value at 1st patameter" do
    state = {1, [21, 14, 32768, 32769, 0], [0, 0, 0, 0, 0, 0, 0, 0], []}
    {4, [21, 14, 32768, 32769, 0], new_registers, []} = VirtualMachine.bitwise_not(state)
    assert new_registers == [32767, 0, 0, 0, 0, 0, 0, 0]
  end

end
