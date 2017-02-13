defmodule VirtualMachine do

  @bit_size 16
  @address_start 32768
  @address_end 32775

  def load_binary(raw_binary_input) do
    do_load_binary([], raw_binary_input)
  end

  defp do_load_binary(loaded_binary,
    <<current_value::little-integer-size(@bit_size), remaining_input::binary>>) do
      do_load_binary(loaded_binary ++ [current_value], remaining_input)
  end

  defp do_load_binary(loaded_binary, "\n") do
    loaded_binary
  end


  def run_instructions(instructions) do
    do_run_instructions(0, instructions, [[],[],[],[],[],[],[],[]], [])
  end

  def do_run_instructions(cursor, instructions, registers, stack) do
    current_instruction = Enum.at(instructions, cursor)
    case current_instruction do
      0 ->
        exit (:shutdown)
      6 ->
        new_cursor = jump_operation(cursor, instructions, registers)
        do_run_instructions(new_cursor, instructions, registers, stack)
      19 ->
        out_operation(cursor, instructions, registers)
        do_run_instructions(cursor+2, instructions, registers, stack)
      21 ->
        do_run_instructions(cursor+1, instructions, registers, stack)
      _ ->
        IO.puts "**** operation not implemented: #{current_instruction} *****"
    end
  end

  def jump_operation(cursor, instructions, registers) do
    new_cursor_or_address = Enum.at(instructions, cursor+1)
    new_cursor = get_argument_value(new_cursor_or_address, instructions, registers)
  end

  def out_operation(cursor, instructions, registers) do
    char_value_or_address = Enum.at(instructions, cursor+1)
    char_to_print = get_argument_value(char_value_or_address, instructions, registers)
    IO.write([char_to_print])
  end

  def get_argument_value(address_or_value, instructions, registers) do
    if (register_address?(address_or_value)) do
      data_address = address_or_value - @address_start
      [value] = Enum.at(registers, data_address)
      value
    else
      address_or_value
    end
  end

  defp register_address?(address_or_value) do
    address_or_value >= @address_start and
    address_or_value <= @address_end
  end

end
