require 'set' unless defined?(Set)

grid = {}
$xmax = 0
$ymax = 0
initial = nil
heading = [0, -1]
ROTATION = {
  [0, -1] => [1, 0],
  [1, 0] => [0, 1],
  [0, 1] => [-1, 0],
  [-1, 0] => [0, -1]
}

def apply(pos, delta)
  [pos[0] + delta[0], pos[1] + delta[1]]
end

$stdin.each_line.each_with_index do |line, y|
  $ymax = [$ymax, y].max
  line.strip.chars.each_with_index do |chr, x|
    $xmax = [$xmax, x].max
    if chr == "^"
      initial = [x, y]
    elsif chr == "#"
      grid[[x, y]] = chr
    end
  end
end

position = initial
visited = Set.new([position, heading])

loop do
  if grid[apply(position, heading)] == "#"
    heading = ROTATION[heading]
    next
  end

  position = apply(position, heading)

  (x, y) = position
  break if x > $xmax || y > $ymax || x < 0 || y < 0

  visited << [position, heading]
end

candidates = visited.to_a.select do |(pos, heading)|
  case heading
  when [1, 0]
    (pos[1]..$ymax).any? do |y|
      grid[[pos[0] - 1, y]] == "#"
    end
  when [-1, 0]
    (0..pos[1]).any? do |y|
      grid[[pos[0] + 1, y]] == "#"
    end
  when [0, 1]
    (0..pos[0]).any? do |x|
      grid[[x, pos[1] - 1]] == "#"
    end
  when [0, -1]
    (pos[0]..$xmax).any? do |x|
      grid[[x, pos[1] + 1]] == "#"
    end
  end
end

def loops?(grid, position, candidate)
  heading = [0, -1]
  visited = Set.new([position, heading])
  grid = grid.dup
  grid[candidate] = "#"

  loop do
    if grid[apply(position, heading)] == "#"
      heading = ROTATION[heading]
      next
    end

    position = apply(position, heading)

    (x, y) = position
    return false if x > $xmax || y > $ymax || x < 0 || y < 0

    return true if visited.member?([position, heading])

    visited << [position, heading]
  end
end

puts(candidates.map(&:first).uniq.select do |candidate|
  loops?(grid, initial, candidate)
end.count)
