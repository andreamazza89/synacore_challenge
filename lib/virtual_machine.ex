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
      2 ->
        push_into_stack(state)
      4 ->
        set_to_one_if_equals(state)
      6 ->
        jump(state)
      7 ->
        jump_to_2nd_param_if_not_zero(state)
      8 ->
        jump_to_2nd_param_if_zero(state)
      9 ->
        add_registers(state)
      19 ->
        out_operation(state)
      21 ->
        no_operation(state)
      _ ->
        IO.puts "**** operation not implemented: #{current_instruction} *****"
    end
    do_run_instructions(new_state)
  end

  def set_register(state = {cursor, instructions, registers, stack}) do
    register_to_update = get_register_index(instructions, cursor)
    update_to = get_value_of(cursor+2, state)

    new_registers = List.replace_at(registers, register_to_update, update_to)
    new_cursor = cursor + 3

    {new_cursor, instructions, new_registers, stack}
  end

######  these two look very similar....

  def add_registers(state = {cursor, instructions, registers, stack}) do
    register_to_update = get_register_index(instructions, cursor)
    update_to = get_value_of(cursor+2, state) + get_value_of(cursor+3, state)

    new_registers = List.replace_at(registers, register_to_update, update_to)
    new_cursor = cursor + 4

    {new_cursor, instructions, new_registers, stack}
  end

  defp get_register_index(instructions, cursor) do
    Enum.at(instructions, cursor+1) - @first_register
  end

  def push_into_stack(state = {cursor, instructions, registers, stack}) do
    value_to_push = get_value_of(cursor+1, state)
    new_stack = List.insert_at(stack, -1, value_to_push)
    new_cursor = cursor + 2

    {new_cursor, instructions, registers, new_stack}
  end

  def set_to_one_if_equals (state = {cursor, instructions, registers, stack}) do
    register_to_update = get_register_index(instructions, cursor)
    update_to = if (get_value_of(cursor+2, state) == get_value_of(cursor+3, state)) do
                  1
                else
                  0
                end
    new_registers = List.replace_at(registers, register_to_update, update_to)
    new_cursor = cursor + 4

    {new_cursor, instructions, new_registers, stack}
  end

  def jump(state = {cursor, instructions, registers, stack}) do
    new_cursor = get_value_of(cursor+1, state)

    {new_cursor, instructions, registers, stack}
  end

  def jump_to_2nd_param_if_not_zero(state = {cursor, instructions, registers, stack}) do
    first_parameter = get_value_of(cursor+1, state)
    new_cursor = jump_if(first_parameter != 0, state)

    {new_cursor, instructions, registers, stack}
  end

  def jump_to_2nd_param_if_zero(state = {cursor, instructions, registers, stack}) do
    first_parameter = get_value_of(cursor+1, state)
    new_cursor = jump_if(first_parameter == 0, state)

    {new_cursor, instructions, registers, stack}
  end

  defp jump_if(should_jump, state = {cursor, _instructions, _registers, _stack}) do
    if (should_jump) do
      get_value_of(cursor+2, state)
    else
      cursor + 3
    end
  end

  def out_operation(state = {cursor, instructions, registers, stack}) do
    char_to_print = get_value_of(cursor+1, state)
    IO.write([char_to_print])

    {cursor+2, instructions, registers, stack}
  end

  def no_operation(_state = {cursor, instructions, registers, stack}) do
    {cursor+1, instructions, registers, stack}
  end






  def get_value_of(cursor_of_value, _state = {_cursor, instructions, registers, _stack}) do
    address_or_value = Enum.at(instructions, cursor_of_value)
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
