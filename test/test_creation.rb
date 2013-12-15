require 'helper'

class TestTopN < Minitest::Test
  def test_creation_without_arguments
    topn = TopN.new
    assert topn
  end

  def test_creation_without_arguments_sets_maxsize_to_some_positive_default
    topn = TopN.new
    assert topn.maxsize > 0
  end

  def test_creation_with_maxsize
    topn = TopN.new(maxsize: 100)
    assert topn.maxsize == 100
  end

  def test_creation_with_direction
    topn = TopN.new(direction: :bottom)
    assert topn.direction == :bottom
  end

  def test_creation_raises_assertion_with_bad_direction
    assert_raises(ArgumentError) {
      TopN.new(direction: :flarg)
    }
  end

  def test_creation_raises_assertion_with_zero_maxsize
    assert_raises(ArgumentError) {
      TopN.new(maxsize: 0)
    }
  end

  def test_creation_raises_assertion_with_negative_maxsize
    assert_raises(ArgumentError) {
      TopN.new(maxsize: -1)
    }
  end

  def test_creation_raises_assertion_with_non_fixnum_maxsize
    assert_raises(ArgumentError) {
      TopN.new(maxsize: 'foo')
    }
  end
end
