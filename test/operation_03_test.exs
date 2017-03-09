defmodule OperationThreeTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "operation 3-pop: set register at 1st parameter to value popped from stack example one" do
    state = {0, [3, 32772, 0], [0, 0, 0, 0, 44, 0, 0, 0], [23, 42]}
    {2, [3, 32772, 0], new_registers, [23]} = VirtualMachine.pop_from_stack(state)
    assert new_registers == [0, 0, 0, 0, 42, 0, 0, 0]
  end


  test "operation 3-pop: set register at 1st parameter to value popped from stack example two" do
    state = {1, [21, 3, 32773, 0], [0, 0, 0, 0, 0, 4, 0, 0], [23, 55]}
    {3, [21, 3, 32773, 0], new_registers, [23]} = VirtualMachine.pop_from_stack(state)
    assert new_registers == [0, 0, 0, 0, 0, 55, 0, 0]
  end

  #this is from the spec: it is an error but does not explain how to handle it,
  #so guessing it should terminate the program, but maybe this is wrong...at least
  # I will print a warning...
  test "operation 3-pop: prints error and exits if stack is empty" do
    capture_io(fn() ->
      state = {1, [21, 3, 32773, 0], [0, 0, 0, 0, 0, 4, 0, 0], []}

      assert catch_exit(VirtualMachine.pop_from_stack(state)) == :empty_stack_error
    end)
  end

end
