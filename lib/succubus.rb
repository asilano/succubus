module Succubus
  class ParseError < RuntimeError
    attr_accessor :errors
  end
  
  class ExecuteError < RuntimeError
    attr_accessor :errors, :partial
  end
  
  class Grammar
    def initialize(&block)
      @rules = {}      
      @errors = []
      define_singleton_method(:create, block)
      create
      class << self ; undef_method :create ; end
      
      unless @errors.empty?
        pe = ParseError.new("Errors found parsing")
        pe.errors = @errors
        raise pe
      end
    end

    def add_rule(name, *choices, &block)
      name = name.to_sym
      @errors << "Duplicate rule definition: #{name}" if @rules.include? name
      @rules[name] = choices
    end
    
    def execute(start)
      gen = Generator.new(@rules)
      gen.run(start)
      
      unless gen.errors.empty?
        ee = ExecuteError.new("Errors found executing")
        ee.errors = gen.errors
        ee.partial = gen.result
        raise ee
      end
      
      gen.result
    end
  end
  
  class Generator
    attr_reader :result
    attr_reader :errors
    
    def initialize(rules)
      @result = ""
      @rules = rules
      @errors = []
    end
    
    def run(rule)
      @result = invoke(rule)
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