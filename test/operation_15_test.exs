defmodule OperationFifteenTest do
  use ExUnit.Case

  test "operation 15rmem: set register at 1st parameter to memory value of 2nd parameter" do
    state = {0, [15, 32768, 3, 42, 0], [0, 0, 0, 0, 0, 0, 0, 0], []}
    {3, [15, 32768, 3, 42, 0], new_registers, []} = VirtualMachine.rmem(state)
    assert [42,0,0,0,0,0,0,0] == new_registers
  end

  test "operation 15-rmem: set register at 1st paramter to memory value at 2nd parameter" do
    state = {1, [21, 15, 32768, 32769, 44, 0], [0, 4, 0, 0, 0, 0, 0, 0], []}
    {4, [21, 15, 32768, 32769, 44, 0], new_registers, []} = VirtualMachine.rmem(state)
    assert [44, 4, 0, 0, 0, 0, 0, 0] = new_registers

  end

end

