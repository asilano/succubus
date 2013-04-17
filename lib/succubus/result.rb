module Succubus
  class Result < String
    attr_reader :random_seed
    
    def initialize(seed, *args, &block)
      @random_seed = seed
      super(*args, &block)
    end
  end
end