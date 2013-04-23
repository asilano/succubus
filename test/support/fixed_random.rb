module MiniTest::Assertions
  @@queued_random = []
  
  def self.queued_random; @@queued_random; end
  def self.next_random; @@queued_random.shift; end
  
  def expect_random(max, choice)
    assert_includes (0...max), choice, "Can't queue rand(#{max.inspect}) => #{choice}; choice not in [0-1)"
    unless max.nil?
      assert_kind_of Integer, choice, "Can't queue rand(#{max}) => #{choice}; choice not an integer"
    end
    @@queued_random << {:max => max, :choice => choice}
  end
  
  def queue_must_be_used
    assert_empty @@queued_random, "Expected to have used all queued random choices: #{@@queued_random.length} left"
  end
end

unless Kernel.method_defined? :rand_with_predefined_values
  module Kernel
    def rand_with_predefined_values(max=nil, &block)
      queued = MiniTest::Assertions.queued_random
      if !queued.empty? && queued[0][:max] == max
        expected = MiniTest::Assertions.next_random
        return expected[:choice]
      else
        if max
          rand_without_predefined_values(max, &block)
        else
          rand_without_predefined_values(&block)
        end
      end
    end
    alias_method :rand_without_predefined_values, :rand
    alias_method :rand, :rand_with_predefined_values
    
  end
end
