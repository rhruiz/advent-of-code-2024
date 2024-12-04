state = :initial
left_operand = nil
right_operand = nil
buf = ''
operations = []

initial = -> chr {
  left_operand = nil
  right_operand = nil
  if chr == 'm'
    buf = 'm'
    :waiting_for_mul
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
    operations << [left_operand, right_operand]
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
