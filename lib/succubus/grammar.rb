module Succubus
  class Grammar
    attr_reader :last_seed
    attr_reader :rules

    def initialize(&block)
      @rules = {}      
      @errors = []
      define_singleton_method(:create, block)
      create
      class << self ; undef_method :create ; end

      unless @errors.empty?
        pe = ParseError.new("Errors found parsing")
        pe.set_errors(@errors)
        raise pe
      end
    end

    def add_rule(name, *choices, &block)
      name = name.to_sym
      @errors << "Duplicate rule definition: #{name}" if @rules.include? name
      @rules[name] = choices
    end

    def execute(start, seed=nil)
      result = Generator.run(self, start, seed)

      unless result.errors.empty?
        ee = ExecuteError.new("Errors found executing")
        ee.set_errors(result.errors)
        ee.set_partial(result)
        raise ee
      end

      @last_seed = result.random_seed
      result
    end
  end
end