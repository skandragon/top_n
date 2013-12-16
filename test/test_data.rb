require 'helper'

class TestData < Minitest::Test
  def test_data_is_empty_on_create
    topn = TopN.new(maxkeys: 2)
    assert_equal({}, topn.data)
  end

  def test_data_has_keys
    topn = TopN.new(maxkeys: 2)
    assert topn.add(1, 1), "add(1, 1) failed"
    assert topn.add(2, 2), "add(1, 1) failed"
    assert topn.add(3, 3), "add(1, 1) failed"
    assert_equal [2, 3], topn.data.keys.sort
  end

  def test_keys
    topn = TopN.new(maxkeys: 2)
    assert topn.add(1, 1), "add(1, 1) failed"
    assert topn.add(2, 2), "add(1, 1) failed"
    assert topn.add(3, 3), "add(1, 1) failed"
    assert_equal [2, 3], topn.keys.sort
  end
end
