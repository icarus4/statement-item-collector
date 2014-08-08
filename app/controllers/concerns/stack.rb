class Stack
  def initialize
    @stack = Array.new
  end

  def pop(pop_count=1)
    @stack.pop(pop_count)
  end

  def top
    @stack.last
  end

  def push(element)
    @stack.push(element)
    self
  end

  def size
    @stack.size
  end
end
