# frozen_string_literal: true

class TestRewriter2
  def call
    x = 1 + 2
    multiply(x, 3)
    multiply(x, 2) if rand > 0.5
  end

  def multiply(x, y)
    x * y
  end
end
