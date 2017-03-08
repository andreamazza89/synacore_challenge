defmodule OperationOneTest do
  use ExUnit.Case

  test "operation 1-set: set register at 1st parameter to value at 2nd parameter" do
    state = {0, [1,32768,32769,0], [0,24,0,0,0,0,0,0], []}
    {3, [1,32768,32769,0], updated_registers, []} = VirtualMachine.set_register(state)
    assert [24,24,0,0,0,0,0,0] == updated_registers
  end

  test "operation 1-set: set register at 1st parameter to value of 2nd parameter" do
    state = {1, [21,1,32769,42,0], [0,0,0,0,0,0,0,0], []}
    {4, [21,1,32769,42,0], updated_registers, []} = VirtualMachine.set_register(state)
    assert [0,42,0,0,0,0,0,0] == updated_registers
  end

end
