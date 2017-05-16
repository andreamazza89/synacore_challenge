defmodule OperationTwentyTest do
  use ExUnit.Case

  test "operation 20-in: writes ascii code of input character to register at 1st parameter" do
    {:ok, io} = StringIO.open("A")
    state = {0, [20, 32768, 0], [0, 0, 0, 0, 0, 0, 0, 0], []}
    {2, [20, 32768, 0], [65, 0, 0, 0, 0, 0, 0, 0], []} = VirtualMachine.input(state, io)
  end

  test "operation 20-in: writes ascii code of input character to register at 1st parameter example two" do
    {:ok, io} = StringIO.open("y")
    state = {1, [21, 20, 32769, 0], [0, 0, 0, 0, 0, 0, 0, 0], []}
    {3, [21, 20, 32769, 0], [0, 121, 0, 0, 0, 0, 0, 0], []} = VirtualMachine.input(state, io)
  end

end
