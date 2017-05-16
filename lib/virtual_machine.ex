defmodule VirtualMachine do
  use Bitwise

  @bit_size 16
  @first_register 32768
  @last_register 32775
  @ascii_zero 48

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
      3 ->
        pop_from_stack(state)
      4 ->
        set_to_one_if_equals(state)
      5 ->
        set_to_one_if_greater(state)
      6 ->
        jump(state)
      7 ->
        jump_to_2nd_param_if_not_zero(state)
      8 ->
        jump_to_2nd_param_if_zero(state)
      9 ->
        add_registers(state)
      10 ->
        mult_registers(state)
      11 ->
        mod_registers(state)
      12 ->
        bitwise_and(state)
      13 ->
        bitwise_or(state)
      14 ->
        bitwise_not(state)
      15 ->
        rmem(state)
      16 ->
        wmem(state)
      17 ->
        call(state)
      18 ->
        ret(state)
      19 ->
        out_operation(state)
      20 ->
        input(state, :stdio)
      21 ->
        no_operation(state)
      _ ->
        IO.puts "\u001B[34m"
                  <>"\n**** operation not implemented: #{current_instruction} *****"
                  <>"\n========================================================"
                  <>"\u001B[0m"
    end
    do_run_instructions(new_state)
  end

### PROPOSED REFACTOR:
###
### `get_value_of` is always used with `cursor+n`, n being which parameter to extract
### instead we could have a few functions with the parameter number baked in, for
### instance: get_value_of(cursor+1, state) would become extract_1st_param(state)

  def set_register(state = {cursor, instructions, registers, stack}) do
    register_to_update = get_register_index(instructions, cursor)
    update_to = get_value_of(cursor+2, state)

    new_registers = List.replace_at(registers, register_to_update, update_to)
    new_cursor = cursor + 3

    {new_cursor, instructions, new_registers, stack}
  end

  def add_registers(state = {cursor, instructions, registers, stack}) do
    register_to_update = get_register_index(instructions, cursor)
    update_to = Integer.mod((get_value_of(cursor+2, state) + get_value_of(cursor+3, state)), @first_register)

    new_registers = List.replace_at(registers, register_to_update, update_to)
    new_cursor = cursor + 4

    {new_cursor, instructions, new_registers, stack}
  end

  def mult_registers(state = {cursor, instructions, registers, stack}) do
    register_to_update = get_register_index(instructions, cursor)
    update_to = Integer.mod((get_value_of(cursor+2, state) * get_value_of(cursor+3, state)), @first_register)

    new_registers = List.replace_at(registers, register_to_update, update_to)
    new_cursor = cursor + 4

    {new_cursor, instructions, new_registers, stack}
  end

  def mod_registers(state = {cursor, instructions, registers, stack}) do
    register_to_update = get_register_index(instructions, cursor)
    update_to = Integer.mod(get_value_of(cursor+2, state), get_value_of(cursor+3, state))

    new_registers = List.replace_at(registers, register_to_update, update_to)
    new_cursor = cursor + 4

    {new_cursor, instructions, new_registers, stack}
  end

  def rmem(state = {cursor, instructions, registers, stack}) do
    register_to_update = get_register_index(instructions, cursor)
    update_to = Enum.at(instructions, get_value_of(cursor+2, state))

    new_registers = List.replace_at(registers, register_to_update, update_to)
    new_cursor = cursor + 3

    {new_cursor, instructions, new_registers, stack}
  end

  def wmem(state = {cursor, instructions, registers, stack}) do
    instructions_address_to_update = get_value_of(cursor+1, state)
    update_to = get_value_of(cursor+2, state)

    new_instructions = List.replace_at(instructions, instructions_address_to_update, update_to)
    new_cursor = cursor + 3

    {new_cursor, new_instructions, registers, stack}
  end

  def ret({_cursor, instructions, registers, stack}) do
    {new_cursor, new_stack} = List.pop_at(stack, -1)
    {new_cursor, instructions, registers, new_stack}
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

  def bitwise_and(state = {cursor, instructions, registers, stack}) do
    register_to_update = get_register_index(instructions, cursor)
    update_to = get_value_of(cursor+2, state) &&& get_value_of(cursor+3, state)

    new_registers = List.replace_at(registers, register_to_update, update_to)
    new_cursor = cursor + 4

    {new_cursor, instructions, new_registers, stack}
  end

  def bitwise_or(state = {cursor, instructions, registers, stack}) do
    register_to_update = get_register_index(instructions, cursor)
    update_to = get_value_of(cursor+2, state) ||| get_value_of(cursor+3, state)

    new_registers = List.replace_at(registers, register_to_update, update_to)
    new_cursor = cursor + 4

    {new_cursor, instructions, new_registers, stack}
  end

  def bitwise_not(state = {cursor, instructions, registers, stack}) do
    register_to_update = get_register_index(instructions, cursor)
    {update_to, _} = get_value_of(cursor+2, state)
      |> Integer.to_string(2)
      |> bit_padding
      |> flip_bits
      |> Integer.parse(2)

    new_registers = List.replace_at(registers, register_to_update, update_to)
    new_cursor = cursor + 3

    {new_cursor, instructions, new_registers, stack}
  end

  defp flip_bits(bits) do
    bits
      |> String.to_charlist
      |> Enum.reduce("", fn(bit, acc) -> if(bit == @ascii_zero) do acc<>"1" else acc<>"0" end end)
  end

  defp bit_padding(bits) do
    zeroes_to_add = 15 - String.length(bits)
    String.duplicate("0", zeroes_to_add) <> bits
  end

  def call(state = {cursor, instructions, registers, stack}) do
    new_stack = List.insert_at(stack, -1, cursor+2)
    new_cursor = get_value_of(cursor+1, state)

    {new_cursor, instructions, registers, new_stack}
  end

  def pop_from_stack({cursor, instructions, registers, stack}) do
    register_to_update = get_register_index(instructions, cursor)
    {update_to, new_stack} = List.pop_at(stack, -1)
    if (update_to != nil) do
      new_registers = List.replace_at(registers, register_to_update, update_to)
      new_cursor = cursor + 2

      {new_cursor, instructions, new_registers, new_stack}
    else
      IO.puts("\u001B[34m"<>"Error from operation 3: stack was empty"<>"\u001B[0m")
      exit(:empty_stack_error)
    end
  end

  def set_to_one_if_equals (state = {cursor, _instructions, _registers, _stack}) do
    set_to_one_if(get_value_of(cursor+2, state) == get_value_of(cursor+3, state), state)
  end

  def set_to_one_if_greater (state = {cursor, _instructions, _registers, _stack}) do
    set_to_one_if(get_value_of(cursor+2, state) > get_value_of(cursor+3, state), state)
  end

  def set_to_one_if(should_set, {cursor, instructions, registers, stack}) do
    register_to_update = get_register_index(instructions, cursor)
    update_to = if (should_set) do
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
    IO.write("\u001B[34m" <> List.to_string([char_to_print]) <> "\u001B[0m")

    {cursor+2, instructions, registers, stack}
  end

  def input(state = {cursor, instructions, registers, stack}, io) do
    register_to_update = get_register_index(instructions, cursor)
    update_to = IO.gets(io, "\n")
                  |> String.to_charlist
                  |> List.first

    new_registers = List.replace_at(registers, register_to_update, update_to)
    new_cursor = cursor + 2

    {new_cursor, instructions, new_registers, stack}
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
