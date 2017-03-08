defmodule OperationNineteenTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "operation 19-out: prints the given (ASCII) value to the console" do
    console_out = capture_io(fn() ->
      state = {0, [19, 88], [], []};
      {new_cursor, [19, 88], [], []} = VirtualMachine.out_operation_19(state)
      assert new_cursor == 2
    end)

    assert console_out == "X"
  end

  test "operation 19-out: prints the referenced (ASCII) value to the console" do
    # register address starts at 32768
    console_out = capture_io(fn() ->
      state = {0, [19, 32768], [89,0,0,0,0,0,0,0], []};
      {new_cursor, [19, 32768], [89,0,0,0,0,0,0,0], []} = VirtualMachine.out_operation_19(state)
      assert new_cursor == 2
    end)

    assert console_out == "Y"
  end

end
