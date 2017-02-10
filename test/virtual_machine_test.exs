defmodule SynacoreChallengeTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "loads little endian 16-bit binary input into memory" do
    little_endian_binary_input = <<21, 0, 19, 15, 133, 1>>
    loaded_input = [21, 3859, 389]
    assert VirtualMachine.load_binary(little_endian_binary_input) == loaded_input
  end


  test "loads another little endian 16-bit binary input into memory" do
    little_endian_binary_input = <<19, 15, 133, 1, 21, 0>>
    loaded_input = [3859, 389, 21]
    assert VirtualMachine.load_binary(little_endian_binary_input) == loaded_input
  end

  test "operation 0-halt: stops execution and terminates the program" do
    assert catch_exit(VirtualMachine.run_instructions([0])) == :shutdown
  end

  test "operation 19-out: prints the given (ASCII) value to the console" do
    console_out = capture_io(fn() -> VirtualMachine.run_instructions([19, 88]) end)
    assert console_out == "X\n"
  end

  test "operation 19-out: prints the referenced (ASCII) value to the console" do
    #imlement me once you can write into registers
  end

  test "operation 21-noop: no operation (skips to the next index)" do
    console_out = capture_io(fn() -> VirtualMachine.run_instructions([21, 19, 88]) end)
    assert console_out == "X\n"
  end

end
