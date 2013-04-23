module Succubus
  # Class which handles running through a {Grammar} and producing a
  # {Result} string.
  #
  # @private
  class Generator
  
    # Run through a given {Grammar}, starting at a given rule. Optionally
    # use a given random seed.
    #
    # @param [Grammar] grammar the {Grammar} to generate a string from
    # @param [Symbol] rule the name of the rule to start generation from
    # @param [Integer] seed optional random seed. Defaults to +nil+, which will
    #   make the {Generator} use a random seed
    def self.run(grammar, rule, seed=nil)
      new(grammar, seed).run(rule)
    end

    # Create a new {Generator}, ready to run through the supplied {Grammar},
    # optionally with the given random seed.
    #
    # @param [Grammar] grammar the {Grammar} to generate a string from
    # @param [Integer] seed optional random seed. Defaults to +nil+, which will
    #   make the {Generator} use a random seed
    def initialize(grammar, seed=nil)
      @rules = grammar.rules

      @seed = seed
      unless @seed
        srand()
        @seed = rand(0xffffffff)
      end
      srand(@seed)

      @errors = []
    end

    # Produce a random {Result} string from the Generator's {Grammar}
    #
    # @param [Symbol] rule the name of the rule to start generation from
    # @return [Result] the {Result} string produced
    def run(rule)
      @result = Result.new(@seed, invoke(rule))
      @result.set_errors(@errors)

      return @result
    end

  private
    # Execute a single rule all the way down, returning the +String+ randomly
    # produced from it
    #
    # @param [Symbol] rule the name of the rule to execute
    # @return [String] the string produced
    def invoke(rule)
      # Check the rule is defined; error if so
      unless @rules.include? rule
        @errors << "No such rule: #{rule}"
        return "!!#{rule}!!"
      end

      local_res = ""
      # Pick an option, and scan it for all instances of (unescaped) <rules>
      # Each match will be an array containing the portion of string before
      # the <rule>; and the <rule> itself (which may be empty on the last match)
      @rules[rule].sample.scan(/(.*?(?<!\\)(?:\\\\)*)(<.*?>|$)/) do |match|
        local_res << match[0]
        unless match[1].empty?
          local_res << invoke(match[1].match(/<(.*?)>/)[1].to_sym)
        end
      end

      return local_res
    end
  end
end