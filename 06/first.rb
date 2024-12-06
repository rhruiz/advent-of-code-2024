grid = {}
xmax = 0
ymax = 0
position = nil
heading = [0, -1]
rotation = {
  [0, -1] => [1, 0],
  [1, 0] => [0, 1],
  [0, 1] => [-1, 0],
  [-1, 0] => [0, -1]
}

def apply(pos, delta)
  [pos[0] + delta[0], pos[1] + delta[1]]
end

$stdin.each_line.each_with_index do |line, y|
  ymax = [ymax, y].max
  line.strip.chars.each_with_index do |chr, x|
    xmax = [xmax, x].max
    if chr == "^"
      position = [x, y]
    elsif chr == "#"
      grid[[x, y]] = chr
    end
  end
end

visited = Set.new([position])

loop do
  if grid[apply(position, heading)] == "#"
    heading = rotation[heading]
    next
  end

  position = apply(position, heading)

  (x, y) = position
  break if x > xmax || y > ymax || x < 0 || y < 0

  visited << position
end

puts visited.count
