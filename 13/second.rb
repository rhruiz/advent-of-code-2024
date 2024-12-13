# Button A: X+94, Y+34
# Button B: X+22, Y+67
# Prize: X=8400, Y=5400

machines = []
machine = {}
deviation = 10000000000000

$stdin.each_line do |line|
  case line
  when /Button (\w): X\+(\d+), Y\+(\d+)/
    machine[$1.downcase.to_sym] = [$2.to_i, $3.to_i]
  when /Prize: X=(\d+), Y=(\d+)/
    machine[:price] = [$1.to_i, $2.to_i].map { |x| x + deviation }
  else
    machines << machine
    machine = {}
  end
end

machines << machine

def solve(machine)
  (xa, ya) = machine[:a]
  (xb, yb) = machine[:b]
  (xp, yp) = machine[:price]

  det = xa * yb - xb * ya

  return [] if det == 0

  na = (yb * xp - xb * yp) / det
  nb = (xa * yp - ya * xp) / det

  if (na*xa + nb*xb == xp) && (na*ya + nb*yb == yp)
    [[na, nb]]
  else
    []
  end
end

puts machines
  .flat_map(&method(:solve))
  .reduce(0) { |acc, (a, b)| acc + (3 * a + b) }
