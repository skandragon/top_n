require 'helper'

class TestTopN < Minitest::Test
  def test_creation_without_arguments_fails
    TopN.new
  end
end
