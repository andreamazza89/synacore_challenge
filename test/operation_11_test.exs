defmodule OperationElevenTest do
  use ExUnit.Case

  test "operation 11-mod: set register at 1st parameter to mod of values of 2nd/3rd parameters" do
    state = {0, [11, 32768, 41, 2, 0], [0, 0, 0, 0, 0, 0, 0, 0], []}
    {4, [11, 32768, 41, 2, 0], new_registers, []} = VirtualMachine.mod_registers(state)
    assert [1,0,0,0,0,0,0,0] == new_registers
  end

  test "operation 11-mod: set register at 1st parameter to mod of value at 2nd and at 3rd parameters" do
    state = {0, [11, 32774, 32770, 32769, 0], [0, 55, 3, 0, 0, 0, 0, 0], []}
    {4, [11, 32774, 32770, 32769, 0], new_registers, []} = VirtualMachine.mod_registers(state)
    assert [0, 55, 3, 0, 0, 0, 3, 0] == new_registers
  end

end
