IO.puts "\u001B[34m"
          <>"\n\n=========================================================="
          <>"\u001B[0m"
binary = File.read!("./docs/challenge.bin")
instructions = VirtualMachine.load_binary(binary)
VirtualMachine.run_instructions(instructions)
