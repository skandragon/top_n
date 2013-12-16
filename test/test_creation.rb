require 'helper'

class TestTopN < Minitest::Test
  def test_creation_without_arguments
    topn = TopN.new
    assert topn
  end

  def test_creation_without_arguments_sets_maxkeys_to_some_positive_default
    topn = TopN.new
    assert topn.maxkeys > 0
  end

  def test_creation_with_maxkeys
    topn = TopN.new(maxkeys: 100)
    assert topn.maxkeys == 100
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

  def test_creation_raises_assertion_with_zero_maxkeys
    assert_raises(ArgumentError) {
      TopN.new(maxkeys: 0)
    }
  end

  def test_creation_raises_assertion_with_negative_maxkeys
    assert_raises(ArgumentError) {
      TopN.new(maxkeys: -1)
    }
  end

  def test_creation_raises_assertion_with_non_fixnum_maxkeys
    assert_raises(ArgumentError) {
      TopN.new(maxkeys: 'foo')
    }
  end

  def test_creation_raises_assertion_for_invalid_argument_names
    assert_raises(ArgumentError) {
      TopN.new(flarg: 1)
    }
  end
end
