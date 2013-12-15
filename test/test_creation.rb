require 'helper'

class TestTopN < Minitest::Test
  def test_creation_without_arguments_works
    topn = TopN.new
    assert topn
    assert topn.maxsize > 0
  end

  def test_creation_with_maxsize_works
    topn = TopN.new(maxsize: 100)
    assert topn.maxsize == 100
  end

  def test_creation_with_direction_works
    topn = TopN.new(direction: :bottom)
    assert topn.direction == :bottom
  end
end
