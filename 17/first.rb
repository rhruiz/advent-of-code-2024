ip = 0
registers = [0, 0, 0]
program = []
output = []

AX = 0
BX = 1
CX = 2

operands = [
  ->() { 0 },
  ->() { 1 },
  ->() { 2 },
  ->() { 3 },
  ->() { registers[0] },
  ->() { registers[1] },
  ->() { registers[2] },
  ->() { raise "boom" },
]

adv = ->(arg) {
  registers[AX] = (registers[AX] / 2**(operands[arg].call())).truncate
}

bxl = ->(arg) {
  registers[BX] = registers[BX] ^ arg
}

bst = ->(arg) {
  registers[BX] = operands[arg].call() % 8
}

jnz = ->(arg) {
  if registers[AX] != 0
    ip = arg - 2
  end
}

bxc = ->(_arg) {
  registers[BX] = registers[BX] ^ registers[CX]
}

out = ->(arg) {
  output << (operands[arg].call() % 8)
}

bdv = ->(arg) {
  registers[BX] = (registers[0] / 2**(operands[arg].call())).truncate
}

cdv = ->(arg) {
  registers[CX] = (registers[0] / 2**(operands[arg].call())).truncate
}

ops = [adv, bxl, bst, jnz, bxc, out, bdv, cdv]
op_names = %w[adv bxl bst jnz bxc out bdv cdv]

run = ->() {
  loop do
    break if ip >= program.length - 1

    op = program[ip]
    arg = program[ip + 1]

    if ENV["DEBUG"]
      puts "before ip: (#{ip}), registers: #{registers.inspect}, op: [#{op}, arg: #{arg}] => #{op_names[op]}(#{arg})"
    end

    ops[op].call(arg)
    ip = ip + 2

    if ENV["DEBUG"]
      puts "after ip: (#{ip}), registers: #{registers.inspect}, o: #{output.inspect}"
    end
  end
}

fp = ARGV[0].nil? ? $stdin : File.open(ARGV[0], "r")

fp.each_line do |line|
  case line
  when /^Register (\w): (\d+)$/
    registers[$1.ord - 'A'.ord] = $2.to_i
  when /^Program: (.*)$/
    program = $1
      .split(',')
      .map { |i| i.to_i }
  end
end

if ENV["DEBUG"]
  puts registers.inspect
  puts program.inspect
end

run.()

puts output.join(',')
