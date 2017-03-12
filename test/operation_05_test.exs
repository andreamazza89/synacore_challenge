defmodule OperationFiveTest do
  use ExUnit.Case

  test "operation 5-gt: sets register at 1st parameter to 1 if value of 2nd is > that of 3rd" do
    state = {0, [4, 32768, 7, 4, 0], [0, 0, 0, 0, 0, 0, 0, 0], []};
    {4, [4, 32768, 7, 4, 0], new_registers, []} = VirtualMachine.set_to_one_if_greater(state)
    assert new_registers == [1, 0, 0, 0, 0, 0, 0, 0]
  end

  test "operation 5-gt: sets register at 1st parameter to 0 if value of 2nd is not > that of 3rd" do
    state = {0, [4, 32768, 3, 4, 0], [5, 0, 0, 0, 0, 0, 0, 0], []};
    {4, [4, 32768, 3, 4, 0], new_registers, []} = VirtualMachine.set_to_one_if_greater(state)
    assert new_registers == [0, 0, 0, 0, 0, 0, 0, 0]
  end

  test "operation 5-gt: sets register at 1st parameter to 1 if value at 2nd is > that at 3rd" do
    state = {1, [21, 4, 32768, 32770, 32771, 0], [0, 0, 55, 42, 0, 0, 0, 0], []};
    {5, [21, 4, 32768, 32770, 32771, 0], new_registers, []} = VirtualMachine.set_to_one_if_greater(state)
    assert new_registers == [1, 0, 55, 42, 0, 0, 0, 0]
  end

  test "operation 5-gt: sets register at 1st parameter to 0 if value at 2nd is not > that at 3rd" do
    state = {0, [4, 32768, 32769, 32770, 0], [5, 42, 42, 0, 0, 0, 0, 0], []};
    {4, [4, 32768, 32769, 32770, 0], new_registers, []} = VirtualMachine.set_to_one_if_greater(state)
    assert new_registers == [0, 42, 42, 0, 0, 0, 0, 0]
  end

end

