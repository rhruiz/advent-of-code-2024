require 'set' unless defined?(Set)

class Node
  attr_accessor :size, :type, :next, :prev, :id
end

id = -1
tail = nil
head = nil
type = :file
moved = Set.new

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

def next_free_that_fits(head, node)
  return nil if head.id == node.id

  loop do
    return nil if head.nil?
    return nil if head == node
    break if head.type == :free and head.size >= node.size
    head = head.next
  end

  head
end

def checksum(node)
  pos = 0
  sum = 0

  loop do
    break if node.nil?

    (0...(node.size)).each do |index|
      sum += pos * node.id if node.type == :file
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

print_fs(head)

loop do
  break if tail == head

  if moved.member?(tail.id)
    tail = previous_file(tail.prev)
    next
  end

  if (current_free = next_free_that_fits(head, tail)).nil?
    tail = previous_file(tail.prev)
    next
  end

  if tail.size < current_free.size
    new_free = Node.new
    new_free.size = tail.size
    new_free.type = :free
    new_free.next = tail.next
    new_free.prev = tail.prev
    tail.prev.next = new_free

    tail.prev = current_free.prev
    tail.next = current_free
    current_free.prev.next = tail
    current_free.prev = tail
    current_free.size -= tail.size

    moved << tail.id
    tail = previous_file(new_free)
  elsif tail.size == current_free.size
    current_free.type = :file
    current_free.id = tail.id

    new_free = Node.new
    new_free.size = tail.size
    new_free.type = :free
    new_free.next = tail.next
    new_free.prev = tail.prev
    new_free.prev.next = new_free
    new_free.next.prev = new_free

    moved << tail.id
    tail = previous_file(new_free)
  end

  print_fs(head)
end

puts checksum(head)
