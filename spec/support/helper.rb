# frozen_string_literal: true

module SpecHelper
  def read_fixture(filename)
    path = File.join('spec', 'fixtures', filename)
    File.read(path)
  end

  def path_fixture(filename)
    File.join('spec', 'fixtures', filename)
  end
end
