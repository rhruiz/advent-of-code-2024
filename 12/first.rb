require 'set' unless defined?(Set)

grid = {}
xmax = 0
ymax = 0

$stdin.each_line.with_index do |line, y|
  ymax = [y, ymax].max
  line.chomp.each_char.with_index do |c, x|
    xmax = [x, xmax].max
    grid[[x, y]] = c
  end
end

neighbors = ->((x, y)) {
  [[x, y + 1], [x + 1, y], [x, y - 1], [x - 1, y]].map { |p| [p, grid[p]] }
}


queue = [[[0, 0], grid[[0, 0]]]]
visited = Set.new
regions = []
current_type = nil
current_region = nil

green = ->(str) { "\e[32m#{str}\e[0m" }

print_farm = ->{
  return unless ENV['DEBUG']

  (0..ymax).each do |y|
    (0..xmax).each do |x|
      if visited.member?([x, y])
        print green.(grid[[x, y]])
      else
        print grid[[x, y]]
      end
    end
    puts
  end

  puts
}

print_farm.call

loop do
  if queue.empty?
    regions << current_region unless current_region.nil?
    break
  end

  (candidate, type) = queue.shift

  next if visited.member?(candidate)

  ns = neighbors.call(candidate)

  if current_type != type || !ns.any? { |(n, _t)| current_region[:members].member?(n) }
    regions << current_region unless current_region.nil?
    current_region = {
      type: type,
      perimeter: 0,
      area: 0,
      members: Set.new()
    }
    current_type = type
  end

  current_region[:area] += 1
  current_region[:members] << candidate
  visited << candidate

  neighbors.call(candidate).each do |neighbor, ntype|
    if ntype != type
      current_region[:perimeter] += 1
      queue.push([neighbor, ntype]) unless ntype.nil?
    else
      queue.unshift([neighbor, ntype])
    end
  end

  print_farm.call
end

puts regions.inspect if ENV['DEBUG']

puts regions.reduce(0) { |cost, region| cost += region[:area] * region[:perimeter] }
