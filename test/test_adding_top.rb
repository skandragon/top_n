require 'helper'

class TestAddingTop < Minitest::Test
  def test_threshold_key_is_nil_on_create
    topn = TopN.new
    assert_nil topn.threshold_key
  end

  def test_adding_updates_threshold_key
    topn = TopN.new
    topn[5] = 5
    assert_equal 5, topn.threshold_key
  end

  def test_adding_increments_size
    topn = TopN.new
    topn[1] = 1
    assert topn.size == 1, "size == 1 failed"
  end

  def test_adding_without_exceeding_adds
    topn = TopN.new(nil, maxkeys: 10)
    topn[5] = 5
    assert_equal [5], topn[5]
    assert_equal 5, topn.threshold_key
  end

  def test_adding_sets_threshold_key
    topn = TopN.new(nil, maxkeys: 10)
    topn[5] = 5
    assert_equal [5], topn[5]
    assert_equal 5, topn.threshold_key
  end

  def test_adding_without_exceeding
    topn = TopN.new(nil, maxkeys: 10)
    topn[5] = 5
    topn[10] = 10
    assert_equal [5], topn[5]
    assert_equal [10], topn[10]
    assert_equal 5, topn.threshold_key
  end

  def test_adding_larger_without_exceeding_sets_threshold_key
    topn = TopN.new(nil, maxkeys: 10)
    topn[5] = 5
    assert_equal 5, topn.threshold_key
    topn[10] = 10
    assert_equal 5, topn.threshold_key
  end

  def test_adding_smaller_without_exceeding_sets_threshold_key
    topn = TopN.new(nil, maxkeys: 10)
    topn[10] = 10
    assert_equal 10, topn.threshold_key
    topn[5] = 5
    assert_equal 5, topn.threshold_key
  end

  def test_adding_two_values_to_the_same_key
    topn = TopN.new(nil, maxkeys: 10)
    topn[1] = 1
    topn[1] = 2
    assert_equal [1, 2], topn[1].sort
  end

  def test_adding_larger_key_when_limit_will_exceed
    topn = TopN.new(nil, maxkeys: 2)
    topn[1] = 1
    topn[2] = 2
    topn[3] = 3
    assert_equal 2, topn.size
    assert_nil topn[1]
    assert_equal [2], topn[2]
    assert_equal [3], topn[3]
  end

  def test_adding_smaller_key_when_limit_will_exceed
    topn = TopN.new(nil, maxkeys: 2)
    topn[3] = 3
    topn[2] = 2
    topn[1] = 1
    assert_equal 2, topn.size
    assert_nil topn[1]
    assert_equal [2], topn[2]
    assert_equal [3], topn[3]
  end

  def test_torture
    topn = TopN.new(nil, maxkeys: 1000)

    records = []
    300_000.times do
      record = rand(4000)
      records << record
      topn[record] = rand(100_000_000)
    end

    top_records = records.uniq.sort { |a, b| b <=> a }[0..999]
    keys = topn.keys.sort { |a, b| b <=> a }
    assert_equal top_records, keys
  end
end
