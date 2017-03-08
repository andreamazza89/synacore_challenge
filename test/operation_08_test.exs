defmodule OperationEightTest do
  use ExUnit.Case

  test "operation 8-jf: moves to next instruction if first parameter is nonzero" do
    state = {0, [8, 1, 42, 0], [], []}
    {new_cursor, [8, 1, 42, 0], [], []} = VirtualMachine.jump_to_2nd_param_if_zero_8(state)
    assert new_cursor == 3
  end

  test "operation 8-jf: moves to second parameter if first parameter is zero" do
    state = {0, [8, 0, 42, 0], [], []}
    {new_cursor, [8, 0, 42, 0], [], []} = VirtualMachine.jump_to_2nd_param_if_zero_8(state)
    assert new_cursor == 42
  end

  test "operation 8-jf: moves to second parameter (register) if first parameter is zero" do
    state = {0, [8, 0, 32768, 0], [43,0,0,0,0,0,0,0], []}
    {new_cursor, [8, 0, 32768, 0], [43,0,0,0,0,0,0,0], []} = VirtualMachine.jump_to_2nd_param_if_zero_8(state)
    assert new_cursor == 43
  end

end


