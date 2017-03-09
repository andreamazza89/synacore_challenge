defmodule OperationSevenTest do
  use ExUnit.Case

  test "operation 7-jt: moves to next instruction if first parameter is zero" do
    state = {0, [7, 0, 42, 0], [], []}
    {new_cursor, [7, 0, 42, 0], [], []} = VirtualMachine.jump_to_2nd_param_if_not_zero(state)
    assert new_cursor == 3
  end

  test "operation 7-jt: moves to next parameter if first parameter is nonzero" do
    state = {0, [7, 1, 42, 0], [], []}
    {new_cursor, [7, 1, 42, 0], [], []} = VirtualMachine.jump_to_2nd_param_if_not_zero(state)
    assert new_cursor == 42
  end

  test "operation 7-jt: moves to next parameter (register) if first parameter is nonzero" do
    state = {0, [7, 1, 32769, 0], [0,43,0,0,0,0,0,0], []}
    {new_cursor, [7, 1, 32769, 0], [0,43,0,0,0,0,0,0], []} = VirtualMachine.jump_to_2nd_param_if_not_zero(state)
    assert new_cursor == 43
  end

end

