# frozen_string_literal: true

puts ['arg', arg, "\n"].join
class MyTestClass
  def call(arg1, arg2, &block)
    some_call(1, 2)
    [].each do |item|
      block.call(arg1, arg2, item)
    end
    some_another_call(1, 3)
  end

  def some_method(_arg1, _arg2)
    puts 1 + 3
  end
end
