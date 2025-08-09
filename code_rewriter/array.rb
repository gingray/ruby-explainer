# frozen_string_literal: true

# add deep copy method to array
class Array
  def deep_copy(item = self)
    case item
    when Array
      item.map { |el| deep_copy(el) }
    else
      item.dup
    end
  end
end
