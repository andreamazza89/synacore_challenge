defmodule OperationZeroTest do
  use ExUnit.Case

  test "operation 0-halt: stops execution and terminates the program" do
    assert catch_exit(VirtualMachine.run_instructions([0])) == :shutdown
  end

end
