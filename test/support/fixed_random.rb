module MiniTest::Assertions
  @@queued_samples = []
  
  def self.queued_samples; @@queued_samples; end
  def self.next_sample; @@queued_samples.shift; end
  
  def expect_sample(options, *choice)
    assert_includes_all choice, options, "Can't queue #{options.inspect}.sample => #{choice}; choice not in options"
    @@queued_samples << {:options => options, :choice => choice}
  end
  
  def samples_must_be_used
    assert_empty @@queued_samples, "Expected to have used all queued samples: #{@@queued_samples.length} left"
  end
end

unless Array.method_defined? :sample_with_predefined_values
  class Array
    def sample_with_predefined_values(n = nil, &block)
      queued = MiniTest::Assertions.queued_samples
      if !queued.empty? && queued[0][:options] == self && queued[0][:choice].length == (n || 1)
        expected = MiniTest::Assertions.next_sample
        ret = expected[:choice]
        ret = ret[0] if n.nil?
        return ret
      else
        if n
          sample_without_predefined_values(n, &block)
        else
          sample_without_predefined_values(&block)
        end
      end
    end
    alias_method :sample_without_predefined_values, :sample
    alias_method :sample, :sample_with_predefined_values
    
  end
end
