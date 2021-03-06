defmodule SynacoreChallengeMainTest do
  use ExUnit.Case

  #VM does not complain if it encounters values described as invalid in the arch-spec
  #this does not currently cause any problems but keep an eye out

  #test "run whole program" do
  #  IO.puts "\u001B[34m"
  #            <>"\n\n=========================================================="
  #            <>"\u001B[0m"
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
    cursor = 0
    state = {cursor, [19, 32768], [55,0,0,0,0,0,0,0], []}
    assert VirtualMachine.get_value_of(cursor+1, state)
            == 55
  end

  test "reads the value from second register if value is second register address" do
    # register address starts at 32768
    cursor = 1
    state = {cursor, [21, 19, 32769], [0,66,0,0,0,0,0,0], []}
    assert VirtualMachine.get_value_of(cursor+1, state)
            == 66
  end

  test "gives the value back if not to be read from registers" do
    # register address starts at 32768
    cursor = 1
    state = {cursor, [19, 444], [0,0,0,0,0,0,0,0], []}
    assert VirtualMachine.get_value_of(cursor, state)
            == 444
  end

end
