module Succubus
  class Grammar
    attr_reader :last_seed
    
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
    
    def execute(start, seed=nil)
      gen = Generator.new(@rules)
      gen.run(start, seed)
      
      unless gen.errors.empty?
        ee = ExecuteError.new("Errors found executing")
        ee.errors = gen.errors
        ee.partial = gen.result
        raise ee
      end
      
      @last_seed = gen.result.random_seed
      gen.result
    end
  end
end