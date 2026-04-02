# frozen_string_literal: true

class LinkedList
  def initialize
    @head = nil
  end

  def append(value)
    new_node = Node.new(value)
    if @head.nil?
      @head = new_node
    else
      current = @head
      current = current.next_node until current.next_node.nil?
      current.next_node = new_node
    end
  end

  def prepend(value)
    new_node = Node.new(value, @head)
    @head = new_node
  end

  def size
    count = 0
    current = @head
    until current.nil?
      count += 1
      current = current.next_node
    end
    count
  end

  def head
    @head ? @head.value : nil
  end

  def tail
    return nil if @head.nil?
    current = @head
    current = current.next_node until current.next_node.nil?
    current.value
  end

  def at(index)
    return nil if index < 0
    current = @head
    index.times do
      return nil if current.nil?
      current = current.next_node
    end
    current ? current.value : nil
  end

  def pop
    return nil if @head.nil?
    value = @head.value
    @head = @head.next_node
    value
  end

  def contains?(value)
    current = @head
    until current.nil?
      return true if current.value == value
      current = current.next_node
    end
    false
  end

  def index(value)
    current = @head
    idx = 0
    until current.nil?
      return idx if current.value == value
      current = current.next_node
      idx += 1
    end
    nil
  end

  def to_s
    return "" if @head.nil?
    current = @head
    string = ""
    until current.nil?
      string += "( #{current.value} ) -> "
      current = current.next_node
    end
    string += "nil"
  end

  def insert_at(index, *values)
    raise IndexError if index < 0 || index > size

    if index == 0
      values.reverse_each { |v| prepend(v) }
      return
    end

    prev = @head
    (index - 1).times { prev = prev.next_node }

    after = prev.next_node
    values.each do |v|
      new_node = Node.new(v)
      prev.next_node = new_node
      prev = new_node
    end
    prev.next_node = after
  end

  def remove_at(index)
    list_size = size
    raise IndexError if index < 0 || index >= list_size

    if index == 0
      @head = @head.next_node
      return
    end

    prev = @head
    (index - 1).times { prev = prev.next_node }
    prev.next_node = prev.next_node.next_node
  end
end

class Node
  attr_accessor :value, :next_node

  def initialize(value = nil, next_node = nil)
    @value = value
    @next_node = next_node
  end
end