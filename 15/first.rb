
grid = {}
xmax = 0
ymax = 0

instructions = []
reading_instructions = false

robot = nil

$stdin.each_line.with_index do |line, y|
  if line == "\n"
    reading_instructions = true
    next
  end

  if reading_instructions
    instructions += line.strip.chars
    next
  end

  ymax = [ymax, y].max

  line.strip.each_char.with_index do |chr, x|
    xmax = [xmax, x].max

    case chr
    when "#"
      grid[[x, y]] = chr
    when "O"
      grid[[x, y]] = chr
    when "@"
      robot = [x, y]
    end
  end
end

DELTA = {
  ">" => [1, 0],
  "<" => [-1, 0],
  "^" => [0, -1],
  "v" => [0, 1]
}

def apply((x, y), (dx, dy))
  [x + dx, y + dy]
end

def mul((x, y), n)
  [x * n, y * n]
end

print_grid = ->(grid, highlight: nil) {
  return unless ENV["DEBUG"]

  (0..ymax).each do |y|
    (0..xmax).each do |x|
      if [x, y] == highlight
        print "\e[31m#{grid[[x, y]] || "."}\e[0m"
        next
      end

      if robot == [x, y]
        print "\e[36m@\e[0m"
        next
      end

      print grid[[x, y]] || "."
    end
    puts
  end
  puts
}

move = ->(direction) {
  candidate = apply(robot, DELTA[direction])

  case grid[candidate]
  when nil
    robot = apply(robot, DELTA[direction])
  when "O"
    chain = 0

    loop do
      candidate = apply(candidate, DELTA[direction])
      # print_grid.(grid, highlight: candidate)

      case grid[candidate]
      when "O"
        chain += 1
      when "#"
        break
      when nil
        (0..chain).each do |i|
          grid[candidate] = "O"
          candidate = apply(candidate, mul(DELTA[direction], -1))
        end

        robot = apply(robot, DELTA[direction])
        grid.delete(robot)
        break
      end
    end
  end
}

print_grid.(grid)

instructions.each do |direction|
  move.(direction)
  print_grid.(grid)
end

puts(grid.reduce(0) do |sum, ((x, y), chr)|
  if chr == "O"
    sum + 100 * y + x
  else
    sum
  end
end)
