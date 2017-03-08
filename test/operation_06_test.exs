defmodule OperationSixTest do
  use ExUnit.Case

  test "operation 6-jmp: update cursor based on parameter (positive offset)" do
    state = {0, [6, 66], [], []};
    {new_cursor, [6,66], [], []} = VirtualMachine.jump(state)
    assert new_cursor == 66
  end

  test "operation 6-jmp: update cursor based on parameter (positive offset, register)" do
    state = {0, [6, 32770], [0,0,66,0,0,0,0,0], []};
    {new_cursor, [6, 32770], [0,0,66,0,0,0,0,0], []} = VirtualMachine.jump(state)
    assert new_cursor == 66
  end

  test "operation 6-jmp: update cursor based on parameter (negative offset)" do
    state = {3, [21, 21, 21, 6, 1], [], []};
    {new_cursor, [21, 21, 21, 6, 1], [], []} = VirtualMachine.jump(state)
    assert new_cursor == 1
  end

end
