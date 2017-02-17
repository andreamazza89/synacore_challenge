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
    do_run_instructions({0, instructions, [[],[],[],[],[],[],[],[]], []})
  end

  def do_run_instructions(state = {cursor, instructions, registers, stack}) do
    current_instruction = Enum.at(instructions, cursor)
    new_state = case current_instruction do
      0 ->
        exit (:shutdown)
      6 ->
        new_cursor_offset = jump_operation(state)
        update_cursor(state, new_cursor_offset)
      7 ->
        new_cursor_offset = jump_if_not_zero(state)
        update_cursor(state, new_cursor_offset)
      19 ->
        out_operation(cursor, instructions, registers)
        update_cursor(state, 2)
      21 ->
        update_cursor(state, 1)
      _ ->
        IO.puts "**** operation not implemented: #{current_instruction} *****"
    end
    do_run_instructions(new_state)
  end

  def jump_if_not_zero(state={cursor, instructions, registers, _stack}) do
    if (Enum.at(instructions, cursor+1) == 0) do
      3
    else
      new_cursor_or_its_address = Enum.at(instructions, cursor+2)
      new_cursor = get_argument_value(new_cursor_or_its_address, instructions, registers)
      new_cursor - cursor
    end
  end

  def jump_operation({cursor, instructions, registers, _stack}) do
    new_cursor_or_its_address = Enum.at(instructions, cursor+1)
    new_cursor = get_argument_value(new_cursor_or_its_address, instructions, registers)
    new_cursor - cursor
  end

  def out_operation(cursor, instructions, registers) do
    char_value_or_address = Enum.at(instructions, cursor+1)
    char_to_print = get_argument_value(char_value_or_address, instructions, registers)
    IO.write([char_to_print])
  end



  def update_cursor({cursor, instructions, registers, stack}, cusor_offset) do
    new_cursor = cursor + cusor_offset
    {new_cursor, instructions, registers, stack}
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
