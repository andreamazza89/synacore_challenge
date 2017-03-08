defmodule VirtualMachine do

  @bit_size 16
  @first_register 32768
  @last_register 32775

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
    do_run_instructions({0, instructions, [0,0,0,0,0,0,0,0], []})
  end

  def do_run_instructions(state = {cursor, instructions, _registers, _stack}) do
    current_instruction = Enum.at(instructions, cursor)

    new_state = case current_instruction do
      0 ->
        exit (:shutdown)
      1 ->
        set_register(state)
      6 ->
        jump(state)
      7 ->
        jump_to_2nd_param_if_not_zero_7(state)
      8 ->
        jump_to_2nd_param_if_zero_8(state)
      19 ->
        out_operation_19(state)
      21 ->
        no_operation_21(state)
      _ ->
        IO.puts "**** operation not implemented: #{current_instruction} *****"
    end
    do_run_instructions(new_state)
  end

  def set_register(_state = {cursor, instructions, registers, stack}) do
    register_to_update = Enum.at(instructions, cursor+1) - @first_register
    update_to = get_argument_value(Enum.at(instructions, cursor+2), registers)

    new_registers = List.replace_at(registers, register_to_update, update_to)

    new_cursor = cursor + 3

    {new_cursor, instructions, new_registers, stack}
  end

  def jump(_state = {cursor, instructions, registers, stack}) do
    new_cursor_or_its_address = Enum.at(instructions, cursor+1)
    new_cursor = get_argument_value(new_cursor_or_its_address, registers)

    {new_cursor, instructions, registers, stack}
  end

  def jump_to_2nd_param_if_not_zero_7(state = {cursor, instructions, registers, stack}) do
    first_parameter = get_argument_value(Enum.at(instructions, cursor+1), registers)
    new_cursor = jump_if(first_parameter != 0, state)

    {new_cursor, instructions, registers, stack}
  end

  def jump_to_2nd_param_if_zero_8(state = {cursor, instructions, registers, stack}) do
    first_parameter = get_argument_value(Enum.at(instructions, cursor+1), registers)
    new_cursor = jump_if(first_parameter == 0, state)

    {new_cursor, instructions, registers, stack}
  end

  defp jump_if(should_jump, {cursor, instructions, registers, stack}) do
    if (should_jump) do
      new_cursor_or_its_address = Enum.at(instructions, cursor+2)
      get_argument_value(new_cursor_or_its_address, registers)
    else
      cursor + 3
    end
  end

  def out_operation_19(_state = {cursor, instructions, registers, stack}) do
    char_value_or_address = Enum.at(instructions, cursor+1)
    char_to_print = get_argument_value(char_value_or_address, registers)
    IO.write([char_to_print])
    {cursor+2, instructions, registers, stack}
  end

  def no_operation_21(_state = {cursor, instructions, registers, stack}) do
    {cursor+1, instructions, registers, stack}
  end





  def get_argument_value(address_or_value, registers) do
    if (register_address?(address_or_value)) do
      data_address = address_or_value - @first_register
      Enum.at(registers, data_address)
    else
      address_or_value
    end
  end

  defp register_address?(address_or_value) do
    address_or_value >= @first_register and
    address_or_value <= @last_register
  end

end
