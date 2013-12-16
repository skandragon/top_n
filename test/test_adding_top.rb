require 'helper'

class TestAddingTop < Minitest::Test
  def test_threshold_key_is_nil_on_create
    topn = TopN.new
    assert_nil topn.threshold_key
  end

  def test_adding_updates_threshold_key
    topn = TopN.new
    assert topn.add(5, 5), "add(5, 5) failed"
    assert_equal 5, topn.threshold_key
  end

  def test_adding_increments_size
    topn = TopN.new
    assert topn.add(1, 1), "add(1, 1) failed"
    assert topn.size == 1, "size == 1 failed"
  end

  def test_adding_without_exceeding_adds
    topn = TopN.new(maxkeys: 10)
    assert topn.add(5, 5), "add(5, 5) failed"
    assert topn.find(5) == [5], "find(5) failed"
    assert_equal 5, topn.threshold_key
  end

  def test_adding_sets_threshold_key
    topn = TopN.new(maxkeys: 10)
    assert topn.add(5, 5), "add(5, 5) failed"
    assert topn.find(5) == [5], "find(5) failed"
    assert_equal 5, topn.threshold_key
  end

  def test_adding_without_exceeding
    topn = TopN.new(maxkeys: 10)
    assert topn.add(5, 5), "add(5, 5) failed"
    assert topn.add(10, 10), "add(10, 10) failed"
    assert topn.find(5) == [5], "find(5) failed"
    assert topn.find(10) == [10], "find(5) failed"
    assert_equal 5, topn.threshold_key
  end

  def test_adding_larger_without_exceeding_sets_threshold_key
    topn = TopN.new(maxkeys: 10)
    assert topn.add(5, 5), "add(5, 5) failed"
    assert_equal 5, topn.threshold_key
    assert topn.add(10, 10), "add(10, 10) failed"
    assert_equal 5, topn.threshold_key
  end

  def test_adding_smaller_without_exceeding_sets_threshold_key
    topn = TopN.new(maxkeys: 10)
    assert topn.add(10, 10), "add(10, 10) failed"
    assert_equal 10, topn.threshold_key
    assert topn.add(5, 5), "add(5, 5) failed"
    assert_equal 5, topn.threshold_key
  end

  def test_adding_two_values_to_the_same_key
    topn = TopN.new(maxkeys: 10)
    assert topn.add(1, 1), "add(1, 1) failed"
    assert topn.add(1, 2), "add(1, 2) failed"
    assert_equal [1, 2], topn.find(1).sort
  end

  def test_adding_larger_key_when_limit_will_exceed
    topn = TopN.new(maxkeys: 2)
    assert topn.add(1, 1), "add(1, 1) failed"
    assert topn.add(2, 2), "add(1, 1) failed"
    assert topn.add(3, 3), "add(1, 1) failed"
    assert_equal 2, topn.size
    assert_nil topn.find(1)
    assert_equal [2], topn.find(2)
    assert_equal [3], topn.find(3)
  end

  def test_adding_smaller_key_when_limit_will_exceed
    topn = TopN.new(maxkeys: 2)
    assert topn.add(3, 3), "add(1, 1) failed"
    assert topn.add(2, 2), "add(1, 1) failed"
    assert_nil topn.add(1, 1)
    assert_equal 2, topn.size
    assert_nil topn.find(1)
    assert_equal [2], topn.find(2)
    assert_equal [3], topn.find(3)
  end

  def test_torture
    topn = TopN.new(maxkeys: 1000)

    records = []
    300_000.times do
      record = rand(4000)
      records << record
      topn.add(record, rand(100_000_000))
    end

    top_records = records.uniq.sort { |a, b| b <=> a }[0..999]
    keys = topn.keys.sort { |a, b| b <=> a }
    assert_equal top_records, keys
  end
end
