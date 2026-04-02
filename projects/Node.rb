# frozen_string_literal: true

class Node
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array.uniq.sort)
  end

  def build_tree(array)
    return nil if array.empty?

    mid = array.length / 2
    node = Node.new(array[mid])
    node.left = build_tree(array[0...mid])
    node.right = build_tree(array[mid + 1..-1])
    node
  end

  def insert(value)
    @root = insert_recursive(@root, value)
  end

  def delete(value)
    @root = delete_recursive(@root, value)
  end

  def include?(value)
    !!find_node(@root, value)
  end

  def level_order
    return to_enum(:level_order) unless block_given?
    return self if @root.nil?

    queue = [@root]
    until queue.empty?
      node = queue.shift
      yield node.data
      queue << node.left if node.left
      queue << node.right if node.right
    end
    self
  end

  def inorder
    return to_enum(:inorder) unless block_given?
    inorder_recursive(@root) { |data| yield data }
    self
  end

  def preorder
    return to_enum(:preorder) unless block_given?
    preorder_recursive(@root) { |data| yield data }
    self
  end

  def postorder
    return to_enum(:postorder) unless block_given?
    postorder_recursive(@root) { |data| yield data }
    self
  end

  def height(value)
    node = find_node(@root, value)
    return nil unless node
    node_height(node)
  end

  def depth(value)
    node_depth(@root, value, 0)
  end

  def balanced?
    check_balance(@root) != -1
  end

  def rebalance
    data = inorder.to_a
    @root = build_tree(data)
  end

  def pretty_print(node = @root, prefix = '', is_left: true)
    return unless node
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", is_left: false)
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", is_left: true)
  end

  private

  def insert_recursive(node, value)
    return Node.new(value) if node.nil?
    return node if value == node.data

    if value < node.data
      node.left = insert_recursive(node.left, value)
    else
      node.right = insert_recursive(node.right, value)
    end
    node
  end

  def delete_recursive(node, value)
    return nil if node.nil?

    if value < node.data
      node.left = delete_recursive(node.left, value)
    elsif value > node.data
      node.right = delete_recursive(node.right, value)
    else
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      successor = min_value_node(node.right)
      node.data = successor.data
      node.right = delete_recursive(node.right, successor.data)
    end
    node
  end

  def min_value_node(node)
    current = node
    current = current.left until current.left.nil?
    current
  end

  def find_node(node, value)
    return nil if node.nil?
    return node if node.data == value

    value < node.data ? find_node(node.left, value) : find_node(node.right, value)
  end

  def inorder_recursive(node, &block)
    return if node.nil?
    inorder_recursive(node.left, &block)
    yield node.data
    inorder_recursive(node.right, &block)
  end

  def preorder_recursive(node, &block)
    return if node.nil?
    yield node.data
    preorder_recursive(node.left, &block)
    preorder_recursive(node.right, &block)
  end

  def postorder_recursive(node, &block)
    return if node.nil?
    postorder_recursive(node.left, &block)
    postorder_recursive(node.right, &block)
    yield node.data
  end

  def node_height(node)
    return -1 if node.nil?
    [node_height(node.left), node_height(node.right)].max + 1
  end

  def node_depth(node, value, current_depth)
    return nil if node.nil?
    return current_depth if node.data == value

    if value < node.data
      node_depth(node.left, value, current_depth + 1)
    else
      node_depth(node.right, value, current_depth + 1)
    end
  end

  def check_balance(node)
    return 0 if node.nil?

    left_h = check_balance(node.left)
    return -1 if left_h == -1

    right_h = check_balance(node.right)
    return -1 if right_h == -1

    (left_h - right_h).abs > 1 ? -1 : [left_h, right_h].max + 1
  end
end

# Driver Script
tree = Tree.new(Array.new(15) { rand(1..100) })
puts "Balanced? #{tree.balanced?}"

puts "Level order: #{tree.level_order.to_a}"
puts "Preorder: #{tree.preorder.to_a}"
puts "Postorder: #{tree.postorder.to_a}"
puts "Inorder: #{tree.inorder.to_a}"

[150, 200, 250].each { |val| tree.insert(val) }
puts "Balanced after additions? #{tree.balanced?}"

tree.rebalance
puts "Balanced after rebalance? #{tree.balanced?}"

puts "Level order: #{tree.level_order.to_a}"
puts "Preorder: #{tree.preorder.to_a}"
puts "Postorder: #{tree.postorder.to_a}"
puts "Inorder: #{tree.inorder.to_a}"
tree.pretty_print