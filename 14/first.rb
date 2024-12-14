robots = []

$stdin.each_line do |line|
  if line =~ /p=(\d+),(\d+) v=(\-?\d+),(\-?\d+)$/
    robots << {
      p: [$1.to_i, $2.to_i],
      v: [$3.to_i, $4.to_i]
    }
  end
end

(width, height) = if robots.length > 15
                 [101, 103]
               else
                 [11, 7]
               end

move = ->(robot, times) {
  # s = s0 + v*t
  (sx, sy) = robot[:p]
  (vx, vy) = robot[:v]

  [(sx + vx * times) % width, (sy + vy * times) % height]
}

map = robots.map { |robot| move.(robot, 100) }.each_with_object({}) do |pos, map|
  map[pos] ||= 0
  map[pos] += 1
end

quadants = []

map.each_pair do |pos, count|
  (x, y) = pos

  next if x == (width / 2).floor || y == (height / 2).floor

  least = x < (width / 2).floor ? 0 : 1
  more = y < (height / 2).floor ? 0 : 1

  quadants[least * 2 + more] ||= 0
  quadants[least * 2 + more] += count
end

puts quadants.reduce(&:*)
