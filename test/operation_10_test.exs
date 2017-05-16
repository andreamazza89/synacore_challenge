defmodule OperationTenTest do
  use ExUnit.Case

  test "operation 10-mult: set register at 1st parameter to multiplication of values of 2nd/3rd parameters" do
    state = {0, [10, 32768, 40, 2, 0], [0, 0, 0, 0, 0, 0, 0, 0], []}
    {4, [10, 32768, 40, 2, 0], new_registers, []} = VirtualMachine.mult_registers(state)
    assert [80,0,0,0,0,0,0,0] == new_registers
  end

  test "operation 10-mult: set register at 1st parameter to mult of value at 2nd and at 3rd parameters" do
    state = {0, [10, 32774, 32770, 32769, 0], [0, 3, 55, 0, 0, 0, 0, 0], []}
    {4, [10, 32774, 32770, 32769, 0], new_registers, []} = VirtualMachine.mult_registers(state)
    assert [0, 3, 55, 0, 0, 0, 165, 0] == new_registers
  end

  test "operation 10-mult: modulo 32768" do
    state = {0, [10, 32768, 16385, 2, 0], [0, 0, 0, 0, 0, 0, 0, 0], []}
    {4,  [10, 32768, 16385, 2, 0], new_registers, []} = VirtualMachine.mult_registers(state)
    assert [2, 0, 0, 0, 0, 0, 0, 0] == new_registers
  end

end

