defmodule VirtualMachine do

  @bit_size 16
  @register_reference_start 32768
  @register_reference_end 32775

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
      19 ->
        character_to_print = fUNCTION_TO_BE_NAMED(cursor+1, instructions, registers)
        IO.puts([character_to_print])
      21 -> do_run_instructions(cursor+1, instructions, registers, stack)
    end
  end

  def fUNCTION_TO_BE_NAMED(cursor, instructions, registers) do
    if (register_address?(cursor)) do
    else
      Enum.at(instructions, cursor)
    end
  end

  defp register_address?(address_or_value) do
    address_or_value > @register_reference_start and
    address_or_value < @register_reference_end
  end

end
