require "set" unless defined?(Set)

xmax = 0
ymax = 0
grid = {}

position = nil
target = nil
heading = [1, 0]

$stdin.each_line.with_index do |line, y|
  ymax = [y, ymax].max

  line.strip.chars.each.with_index do |c, x|
    xmax = [x, xmax].max

    case c
    when "S"
      position = [x, y]
    when "E"
      target = [x, y]
    when "#"
      grid[[x, y]] = :wall
    end
  end
end

has = ->(heading) {
  case heading
  when [1, 0]
    ">"
  when [-1, 0]
    "<"
  when [0, 1]
    "v"
  when [0, -1]
    "^"
  end
}

neighbours = ->(pos) {
  (x, y) = pos
  (hx, hy) = heading

  h1 = [hy, hx]
  h2 = mul(h1, -1)

  [
    [[x + hx, y + hy], [hx, hy], 1],
    [apply(pos, h1), h1, 1000],
    [apply(pos, h2), h2, 1000]
  ].uniq.select { |(n, _h, _cost)| grid[n] != :wall }
}

# priority queue
def enqueue(queue, priority, item)
  queue.push([priority, item])
  queue.sort_by! { |(p, _)| p }
end

def apply((x, y), (dx, dy))
  [x + dx, y + dy]
end

def mul((x, y), n)
  [x * n, y * n]
end

# djikstra

distance = 0
visited = Set.new()
queue = enqueue([], distance, [position, heading, Set.new])

min_distance = nil

print_grid = ->() {
  (0..ymax).each do |y|
    print "#{y.to_s.ljust(2, " ")} "
    (0..xmax).each do |x|
      if [x, y] == position
        print(has.(heading))
      elsif [x, y] == target
        print "E"
      else
        if visited.include?([x, y])
          print "\e[31m"
        end
        print grid[[x, y]] == :wall ? "#" : "."
        if visited&.include?([x, y])
          print "\e[0m"
        end
      end
    end
    puts
  end
}

print_grid.()

puts heading.inspect
puts neighbours.(position).inspect

loop do
  break if queue.empty?

  (distance, (position, heading, visited)) = queue.shift

  if position == target
    puts distance
    min_distance = distance if min_distance.nil?
    min_distance = [min_distance, distance].min
    break
  end

  if position == [1, 10]
    puts "at [1, 10]"
    puts heading.inspect
    puts neighbours.(position).inspect
  end

  visited << position
  neighbours.(position).each do |(n, nheading, cost)|
    next if visited.include?(n)

    enqueue(queue, distance + cost, [n, nheading, visited.dup])
  end
end

puts min_distance
puts visited.inspect

print_grid.()
