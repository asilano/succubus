module MiniTest::Assertions
  def assert_subset(subset, superset, msg = nil)
    sub = subset.to_a.dup
    supe = superset.to_a.dup
    msg ||= "#{sub.inspect} is not a subset of #{supe.inspect}"
    failed = false
    sub.each do |elem|
      if supe.index(elem)
        supe.delete_at(supe.index(elem) || li.length)
      else
        failed = true
        break
      end
    end

    assert(!failed, msg)
  end

  def assert_disjoint(left, right, msg = nil)
    left_a = left.to_a.dup
    right_a = right.to_a.dup
    msg ||= "#{left_a.inspect} and #{right_a.inspect} are not disjoint"
    failed = false
    left_a.each do |elem|
      if right_a.index(elem)
        failed = true
        break
      end
    end

    assert(!failed, msg)
  end
  
  def assert_same_elements(a1, a2, msg = nil)
    [:select, :inject, :size].each do |m|
      [a1, a2].each {|a| assert_respond_to(a, m, "Are you sure that #{a.inspect} is an array? It doesn't respond to #{m}.") }
    end

    assert a1h = a1.inject({}) { |h,e| h[e] = a1.select { |i| i == e }.size; h }
    assert a2h = a2.inject({}) { |h,e| h[e] = a2.select { |i| i == e }.size; h }

    assert_equal(a1h, a2h, msg)
  end
end

module MiniTest::Expectations
  infect_an_assertion :assert_subset, :must_be_subset_of
  infect_an_assertion :assert_same_elements, :must_have_same_elements_as
end