defmodule OperationFourTest do
  use ExUnit.Case

  test "operation 4-eq: sets register at 1st parameter to 1 if value of 2nd and of 3rd are equal" do
    state = {0, [4, 32768, 4, 4, 0], [0, 0, 0, 0, 0, 0, 0, 0], []};
    {4, [4, 32768, 4, 4, 0], new_registers, []} = VirtualMachine.set_to_one_if_equals(state)
    assert new_registers == [1, 0, 0, 0, 0, 0, 0, 0]
  end

  test "operation 4-eq: sets register at 1st parameter to 0 if value of 2nd and of 3rd are not equal" do
    state = {1, [21, 4, 32769, 4, 5, 0], [0, 42, 0, 0, 0, 0, 0, 0], []};
    {5, [21, 4, 32769, 4, 5, 0], new_registers, []} = VirtualMachine.set_to_one_if_equals(state)
    assert new_registers == [0, 0, 0, 0, 0, 0, 0, 0]
  end

  test "operation 4-eq: sets register at 1st parameter to 1 if value at 2nd and at 3rd are equal" do
    state = {0, [4, 32768, 32770, 32771, 0], [0, 0, 3, 3, 0, 0, 0, 0], []};
    {4, [4, 32768, 32770, 32771, 0], new_registers, []} = VirtualMachine.set_to_one_if_equals(state)
    assert new_registers == [1, 0, 3, 3, 0, 0, 0, 0]
  end

  test "operation 4-eq: sets register at 1st parameter to 0 if value at 2nd and at 3rd are not equal" do
    state = {0, [4, 32768, 32770, 32771, 0], [555, 0, 66, 99, 0, 0, 0, 0], []};
    {4, [4, 32768, 32770, 32771, 0], new_registers, []} = VirtualMachine.set_to_one_if_equals(state)
    assert new_registers == [0, 0, 66, 99, 0, 0, 0, 0]
  end

end
