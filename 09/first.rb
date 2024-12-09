class Node
  attr_accessor :size, :type, :next, :prev, :id
end

id = -1
tail = nil
head = nil
type = :file

$stdin.read.split("").each do |chr|
  size = chr.to_i

  if size != 0
    new = Node.new
    new.size = size
    new.type = type
    new.id = (id += 1) if type == :file
    new.prev = tail if tail
    tail.next = new if tail
    head = new if head.nil?
    tail = new
  end

  type = (type == :file) ? :free : :file
end

current_free = head.next

def previous_file(node)
  current = node

  loop do
    return nil if current.nil?
    break if current.type == :file
    current = current.prev
  end

  current
end

def previous_free(node)
  current = node
  loop do
    return nil if current.nil?
    break if current.type == :free
    current = current.prev
  end

  current
end


def next_free(node)
  current = node

  loop do
    return nil if current.nil?
    break if current.type == :free
    current = current.next
  end

  current
end

def checksum(node)
  pos = 0
  sum = 0

  loop do
    break if node.nil? or node.type == :free

    (0...(node.size)).each do |index|
      sum += pos * node.id
      pos += 1
    end

    node = node.next
  end

  sum
end

def print_fs(node)
  return unless ENV['DEBUG']

  loop do
    break if node.nil?

    if node.type == :free
      print "." * node.size
    else
      print "#{node.id}" * node.size
    end

    node = node.next
  end

  puts
end

loop do
  break if previous_free(tail).nil?

  if tail.size < current_free.size
    new = Node.new
    new.size = tail.size
    new.type = :file
    new.id = tail.id
    new.prev = current_free.prev
    new.next = current_free
    new.prev.next = new
    current_free.size -= tail.size
    current_free.prev = new
    tail.prev.next = nil
    tail = previous_file(tail.prev)
    current_free = next_free(current_free)
  elsif tail.size > current_free.size
    current_free.type = :file
    current_free.id = tail.id
    tail.size -= current_free.size
    current_free = next_free(current_free)
  else
    current_free.type = :file
    current_free.id = tail.id
    current_free = next_free(current_free)
    tail.prev.next = nil
    tail = previous_file(tail.prev)
  end

  print_fs(head)
end

puts checksum(head)
