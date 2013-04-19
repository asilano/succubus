module Succubus
  class Generator
    def self.run(grammar, rule, seed=nil)
      new(grammar, seed).run(rule)
    end

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

    def run(rule)
      @result = Result.new(@seed, invoke(rule))
      @result.set_errors(@errors)

      return @result
    end

  private
    def invoke(rule)
      unless @rules.include? rule
        @errors << "No such rule: #{rule}"
        return "!!#{rule}!!"
      end

      local_res = ""
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