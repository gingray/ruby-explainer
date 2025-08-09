# frozen_string_literal: true

class MyTestClass
  def call(arg1, _arg2)
    call2(arg1)
  end

  def call2(arg1)
    some_check?(arg1)
  end
end
