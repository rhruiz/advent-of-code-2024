require 'set' unless defined?(Set)

grid = {}
xmax = 0
ymax = 0
candidates = []
scores = {}

$stdin.each_line.each_with_index do |line, y|
  ymax = [y, ymax].max
  line.strip.chars.each_with_index do |chr, x|
    xmax = [x, xmax].max
    if chr != '.'
      height = chr.to_i
      grid[[x, y]] = height
      candidates << [x, y] if height == 0
    end
  end
end

neighbors = ->((x, y)) {
  [[1, 0], [0, 1], [-1, 0], [0, -1]].flat_map do |dx, dy|
    newx = x + dx
    newy = y + dy

    if newx <= xmax && newy <= ymax && newx >= 0 && newy >= 0
      [[newx, newy]]
    else
      []
    end
  end
}

candidates.each do |candidate|
  queue = [candidate]
  visited = Set.new

  loop do
    break if queue.empty?
    current = queue.shift

    neighbors.call(current).each do |neighbor|
      next if grid[neighbor].nil?
      next if visited.member?(neighbor)
      next if grid[neighbor] != grid[current] + 1

      visited << neighbor
      queue << neighbor

      if grid[neighbor] == 9
        scores[candidate] ||= 0
        scores[candidate] += 1
      end
    end
  end
end

puts scores.values.sum
