module Succubus
  class Generator
    attr_reader :result
    attr_reader :errors
    
    def initialize(rules)
      @result = ""
      @rules = rules
      @errors = []
    end
    
    def run(rule, seed=nil)
      unless seed
        srand()
        seed = rand(0xffffffff)
      end
      
      srand(seed)
      @result = Result.new(seed, invoke(rule))
    end
    
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