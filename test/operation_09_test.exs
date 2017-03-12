defmodule OperationNineTest do
  use ExUnit.Case

  test "operation 9-add: set register at 1st parameter to sum of values of 2nd/3rd parameters" do
    state = {0, [9, 32768, 40, 2, 0], [0, 0, 0, 0, 0, 0, 0, 0], []}
    {4, [9, 32768, 40, 2, 0], new_registers, []} = VirtualMachine.add_registers(state)
    assert [42,0,0,0,0,0,0,0] == new_registers
  end

  test "operation 9-add: set register at 1st parameter to sum of value at 2nd and of 3rd parameters" do
    state = {1, [21, 9, 32769, 32775, 2, 0], [0, 0, 0, 0, 0, 0, 0, 5], []}
    {5, [21, 9, 32769, 32775, 2, 0], new_registers, []} = VirtualMachine.add_registers(state)
    assert [0,7,0,0,0,0,0,5] == new_registers
  end

  test "operation 9-add: set register at 1st parameter to sum of value of 2nd and at 3rd parameters" do
    state = {0, [9, 32770, 40, 32769, 0], [0, 3, 0, 0, 0, 0, 0, 0], []}
    {4, [9, 32770, 40, 32769, 0], new_registers, []} = VirtualMachine.add_registers(state)
    assert [0, 3, 43, 0, 0, 0, 0, 0] == new_registers
  end

  test "operation 9-add: set register at 1st parameter to sum of value at 2nd and at 3rd parameters" do
    state = {0, [9, 32774, 32770, 32769, 0], [0, 3, 55, 0, 0, 0, 0, 0], []}
    {4, [9, 32774, 32770, 32769, 0], new_registers, []} = VirtualMachine.add_registers(state)
    assert [0, 3, 55, 0, 0, 0, 58, 0] == new_registers
  end

  test "operation 9-add: modulo 32768" do
    state = {0, [9, 32768, 32767, 2, 0], [0, 0, 0, 0, 0, 0, 0, 0], []}
    {4,  [9, 32768, 32767, 2, 0], new_registers, []} = VirtualMachine.add_registers(state)
    assert [1, 0, 0, 0, 0, 0, 0, 0] == new_registers
  end

end
