module Succubus
  # Class which contains the rules describing a grammar from
  # which to generate random strings.
  #
  # {Grammar} provides the vast majority of the user interface
  # to Succubus.
  #
  # @!attribute [r] last_seed
  #   @return [Integer] the random seed used by the last call to {#execute}
  # @!attribute [r] rules
  #   @return [Hash<Symbol => String>] the rules describing this grammar
  class Grammar
    attr_reader :last_seed
    attr_reader :rules

    # Create a new {Grammar} object. {#initialize Grammar.new} should be passed
    # a block defining the rules for the grammar. +self+ in the block will be
    # the newly-created {Grammar} instance
    #
    # @yield Block defining the grammar. +self+ is the newly-created {Grammar},
    #   so bare calls to {#add_rule} work as expected.
    # @raise [ParseError] if errors were encountered parsing the grammar in the
    #   supplied block
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

    # Define a new rule into the {Grammar}.
    #
    # {#add_rule} is usually called from the block parameter of {#initialize Grammar.new};
    # however, it can be called on an existing {Grammar} object. Errors encountered by
    # {#add_rule} will only be reported when called via {#initialize Grammar.new}.
    #
    # @param [#to_sym] name name of the rule
    # @param [Array<String>] choices possible replacements for the rule. When +<name>+ is
    #   encountered during execution of the {Grammar}, +<name>+ will be replaced by one of 
    #   the strings in +choices+ chosen uniformly at random.
    def add_rule(name, *choices)
      name = name.to_sym
      @errors << "Duplicate rule definition: #{name}" if @rules.include? name
      @rules[name] = choices
    end

    # Execute the grammar, producing a random {Result} string.
    #
    # The rule named +start+ is examined, and one of that rule's choices chosen. Then, for each
    # rule reference tag +<name>+ in that choice, the tag is recursively replaced with one of 
    # the choices for the rule named +name+.
    #
    # @param [#to_sym] start name of the rule to start execution at
    # @param [Integer] seed optional random seed. Defaults to +nil+, which will
    #   cause a random seed to be used
    #
    # @raise [ExecuteError] if errors were encountered while executing the grammar
    def execute(start, seed=nil)
      result = Generator.run(self, start.to_sym, seed)

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