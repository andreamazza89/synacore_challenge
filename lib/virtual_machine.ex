defmodule VirtualMachine do

  @bit_size 16

  def load_binary(raw_binary_input) do
    do_load_binary([], raw_binary_input)
  end

  defp do_load_binary(loaded_binary,
                      <<current_value::little-integer-size(@bit_size), remaining_input::binary>>) do
    do_load_binary(loaded_binary ++ [current_value], remaining_input)
  end

  defp do_load_binary(loaded_binary, <<>>) do
    loaded_binary
  end


  def run_instructions(instructions) do
    do_run_instructions(0, instructions, [[],[],[],[],[],[],[],[]], []) #### might want to make these Structs...
  end

  def do_run_instructions(cursor, instructions, registers, stack) do
    current_instruction = Enum.at(instructions, cursor)
    case current_instruction do
      0 -> exit (:shutdown)
      19 -> IO.puts([Enum.at(instructions, cursor + 1)])
      21 -> do_run_instructions(cursor + 1, instructions, registers, stack)
    end
  end

end
