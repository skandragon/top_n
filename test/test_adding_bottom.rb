require 'helper'

class TestAddingBottom < Minitest::Test
  def test_threshold_key_is_nil_on_create
    topn = TopN.new(direction: :bottom)
    assert_nil topn.threshold_key
  end

  def test_adding_updates_threshold_key
    topn = TopN.new(direction: :bottom)
    assert topn.add(5, 5), "add(5, 5) failed"
    assert_equal 5, topn.threshold_key
  end

  def test_adding_increments_size
    topn = TopN.new(direction: :bottom)
    assert topn.add(1, 1), "add(1, 1) failed"
    assert topn.size == 1, "size == 1 failed"
  end

  def test_adding_without_exceeding_adds
    topn = TopN.new(direction: :bottom, maxsize: 10)
    assert topn.add(5, 5), "add(5, 5) failed"
    assert topn.find(5) == [5], "find(5) failed"
    assert_equal 5, topn.threshold_key
  end

  def test_adding_sets_threshold_key
    topn = TopN.new(direction: :bottom, maxsize: 10)
    assert topn.add(5, 5), "add(5, 5) failed"
    assert topn.find(5) == [5], "find(5) failed"
    assert_equal 5, topn.threshold_key
  end

  def test_adding_without_exceeding
    topn = TopN.new(direction: :bottom, maxsize: 10)
    assert topn.add(5, 5), "add(5, 5) failed"
    assert topn.add(10, 10), "add(10, 10) failed"
    assert topn.find(5) == [5], "find(5) failed"
    assert topn.find(10) == [10], "find(5) failed"
    assert_equal 10, topn.threshold_key
  end

  def test_adding_larger_without_exceeding_sets_threshold_key
    topn = TopN.new(direction: :bottom, maxsize: 10)
    assert topn.add(5, 5), "add(5, 5) failed"
    assert_equal 5, topn.threshold_key
    assert topn.add(10, 10), "add(10, 10) failed"
    assert_equal 10, topn.threshold_key
  end

  def test_adding_smaller_without_exceeding_sets_threshold_key
    topn = TopN.new(direction: :bottom, maxsize: 10)
    assert topn.add(10, 10), "add(10, 10) failed"
    assert_equal 10, topn.threshold_key
    assert topn.add(5, 5), "add(5, 5) failed"
    assert_equal 10, topn.threshold_key
  end

  def test_adding_two_values_to_the_same_key
    topn = TopN.new(direction: :bottom, maxsize: 10)
    assert topn.add(1, 1), "add(1, 1) failed"
    assert topn.add(1, 2), "add(1, 2) failed"
    assert_equal [1, 2], topn.find(1).sort
  end

  def test_adding_smaller_key_when_limit_will_exceed
    topn = TopN.new(direction: :bottom, maxsize: 2)
    assert topn.add(3, 3), "add(3, 3) failed"
    assert topn.add(2, 2), "add(2, 2) failed"
    assert topn.add(1, 1), "add(1, 1) failed"
    assert_equal 2, topn.size
    assert_equal [1], topn.find(1)
    assert_equal [2], topn.find(2)
    assert_nil topn.find(3)
  end

  def test_adding_larger_key_when_limit_will_exceed
    topn = TopN.new(direction: :bottom, maxsize: 2)
    assert topn.add(1, 1), "add(1, 1) failed"
    assert topn.add(2, 2), "add(2, 2) failed"
    assert_nil topn.add(3, 3)
    assert_equal 2, topn.size
    assert_equal [1], topn.find(1)
    assert_equal [2], topn.find(2)
    assert_nil topn.find(3)
  end
end
