defmodule SynacoreChallengeTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  #VM does not complain if it encounters values described as invalid in the arch-spec

  #test "run whole program" do
  #  binary = File.read!("./docs/challenge.bin")
  #  instructions = VirtualMachine.load_binary(binary)
  #  VirtualMachine.run_instructions(instructions)
  #end

  test "loads little endian 16-bit binary input into memory" do
    little_endian_binary_input = <<21, 0, 19, 15, 133, 1, "\n">>
    loaded_input = [21, 3859, 389]
    assert VirtualMachine.load_binary(little_endian_binary_input) == loaded_input
  end


  test "loads another little endian 16-bit binary input into memory" do
    little_endian_binary_input = <<19, 15, 133, 1, 21, 0, "\n">>
    loaded_input = [3859, 389, 21]
    assert VirtualMachine.load_binary(little_endian_binary_input) == loaded_input
  end

  test "reads the value from first register if value is first register address" do
    # register address starts at 32768
    assert VirtualMachine.get_argument_value(32768, [6, 32768], [[55],[],[],[],[],[],[],[]])
            == 55
  end

  test "reads the value from second register if value is first register address" do
    # register address starts at 32768
    assert VirtualMachine.get_argument_value(32769, [6, 32769], [[],[66],[],[],[],[],[],[]])
            == 66
  end

  test "gives the value back if not to be read from registers" do
    # register address starts at 32768
    assert VirtualMachine.get_argument_value(444, [6, 444], [[],[],[],[],[],[],[],[]])
            == 444
  end

  test "updates the cursor by the given amount" do
    assert VirtualMachine.update_cursor({0, [4,3], [], []}, 2) == {2, [4,3], [], []}
    assert VirtualMachine.update_cursor({1, [5,3], [77], [66]}, 1) == {2, [5,3], [77], [66]}
  end

  test "operation 0-halt: stops execution and terminates the program" do
    assert catch_exit(VirtualMachine.run_instructions([0])) == :shutdown
  end

  test "operation 6-jmp: offset to new cursor is provided (positive offset)" do
    new_cursor_offset = VirtualMachine.jump_operation({0, [6, 66], [], []})
    assert new_cursor_offset == 66
  end

  test "operation 6-jmp: offset to new cursor is provided (negative offset)" do
    new_cursor_offset = VirtualMachine.jump_operation({3, [21, 21, 21, 6, 1], [], []})
    assert new_cursor_offset == -2
  end

  test "operation 7-jt: moves to next instruction if first parameter is zero" do
    state = {0, [7, 0, 42, 0], [], []}
    new_cursor_offset = VirtualMachine.jump_if_not_zero(state)
    assert new_cursor_offset == 3
  end

  test "operation 7-jt: moves to next parameter if first parameter is nonzero" do
    state = {0, [7, 1, 42, 0], [], []}
    new_cursor_offset = VirtualMachine.jump_if_not_zero(state)
    assert new_cursor_offset == 42
  end

  test "operation 19-out: prints the given (ASCII) value to the console" do
    console_out = capture_io(fn() ->
      VirtualMachine.out_operation(0, [19, 88], [])
    end)

    assert console_out == "X"
  end

  test "operation 19-out: prints the referenced (ASCII) value to the console" do
    # register address starts at 32768
    console_out = capture_io(fn() ->
      VirtualMachine.out_operation(0, [19, 32768], [[89],[],[],[],[],[],[],[]])
    end)

    assert console_out == "Y"
  end

end
