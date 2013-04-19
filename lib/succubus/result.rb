module Succubus
  class Result < String
    attr_reader :random_seed, :errors

    def initialize(seed, *args, &block)
      @random_seed = seed
      super(*args, &block)
    end

    def set_errors(errors)
      @errors = errors
    end
  end
end
