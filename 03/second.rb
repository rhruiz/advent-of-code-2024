state = :initial
left_operand = nil
right_operand = nil
buf = ''
operations = []
enable_mul = true

initial = -> chr {
  left_operand = nil
  right_operand = nil

  case [chr, buf]
  when ['m', '']
    buf = 'm'
    :waiting_for_mul
  when ['d', '']
    buf = 'd'
    :waiting_for_conditional
  else
    :initial
  end
}

waiting_for_conditional = -> chr {
  case [chr, buf]
  when ['o', 'd']
    buf += chr
    :waiting_for_conditional
  when ['(', 'do']
    buf += chr
    :waiting_for_conditional
  when [')', 'do(']
    buf = ''
    enable_mul = true
    :initial
  when ['n', 'do']
    buf += chr
    :waiting_for_conditional
  when ["'", 'don']
    buf += chr
    :waiting_for_conditional
  when ['t', "don'"]
    buf += chr
    :waiting_for_conditional
  when ['(', "don't"]
    buf += chr
    :waiting_for_conditional
  when [')', "don't("]
    buf = ''
    enable_mul = false
    :initial
  else
    :initial
  end
}

waiting_for_mul = -> chr {
  case [chr, buf]
  when ['u', 'm']
    buf = 'mu'
    :waiting_for_mul
  when ['l', 'mu']
    buf = 'mul'
    :waiting_for_mul
  when ['(', 'mul']
    buf = ''
    :reading_left_operand
  else
    buf = ''
    :initial
  end
}

reading_left_operand = -> chr {
  case chr
  when '0'..'9'
    buf += chr
    :reading_left_operand
  when ','
    left_operand = buf.to_i
    buf = ''
    :reading_right_operand
  else
    buf = ''
    :initial
  end
}

waiting_for_comma = -> chr {
  case chr
  when ','
    :reading_right_operand
  else
    buf = ''
    :initial
  end
}

reading_right_operand = -> chr {
  case chr
  when '0'..'9'
    buf += chr
    :reading_right_operand
  when ')'
    right_operand = buf.to_i
    operations << [left_operand, right_operand] if enable_mul
    buf = ''
    :initial
  else
    buf = ''
    :initial
  end
}

next_fn = :initial

$stdin.each_char do |chr|
  next_fn = binding.local_variable_get(next_fn).call(chr)
end

puts operations.reduce(0) { |acc, (left, right)| acc + left * right }
