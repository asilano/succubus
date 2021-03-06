require File.dirname(__FILE__) + '/spec_helper'
require 'succubus'

describe Succubus::Grammar do
  describe "creating grammar" do
    it "should accept valid grammar" do
      Succubus::Grammar.new do
        add_rule :base, "I have a <colour> <pet>"
        add_rule :colour, "black", "white"
        add_rule :pet, "cat", "dog"
      end
    end
    
    it "should reject invalid grammar" do
      proc do
        Succubus::Grammar.new do
          add_rule :base, "I have a <colour> <pet>"
          add_rule :colour, "black", "white"
          add_rule :colour, "cat", "dog"
        end
      end.must_raise Succubus::ParseError
    end
  end
  
  describe "trivial grammar" do
    before do
      @grammar = Succubus::Grammar.new do
        add_rule :base, "Just a single fixed string"
      end
    end
    
    it "should always produce the fixed string" do
      1000.times { @grammar.execute(:base).must_equal "Just a single fixed string" }
    end
  end
  
  describe "simple grammar" do
    before do
      @grammar = Succubus::Grammar.new do
        add_rule :base, "I have a <colour> <pet>", "<pet>s look best in <colour>"
        add_rule :colour, "black", "white"
        add_rule :pet, "cat", "dog"
        add_rule :unreachable, "No-one likes animals anyway"
      end
    end
    
    it "should always produce a valid string" do
      1000.times { @grammar.execute(:base).must_match(/(I have a (black|white) (cat|dog))|((cat|dog)s look best in (black|white))/) }
    end
    
    it "should produce a known string given pre-chosen randomness" do
      # From ["I have a <colour> <pet>", "<pet>s look best in <colour>"], choose "<pet>s look best in <colour>"
      expect_random 2, 1
      # From ["cat", "dog"], choose "cat"
      expect_random 2, 0
      # From ["black", "white"], choose "black"
      expect_random 2, 0
      
      @grammar.execute(:base).must_equal "cats look best in black"
      
      queue_must_be_used
    end
    
    it "should always produce the same string given a known seed" do
      result = @grammar.execute(:base)
      result.random_seed.wont_be_nil
      
      seed = result.random_seed
      100.times { @grammar.execute(:base, seed).must_equal result }
      
      # We know from manual runs that the seed 42 produces "I have a white cat"
      100.times { @grammar.execute(:base, 42).must_equal "I have a white cat" }
    end
  end
  
  describe "failure cases" do
    it "should fail to parse duplicate rules" do
      bad_parse = proc do
        Succubus::Grammar.new do
          add_rule :base, "I have a <colour> <pet>"
          add_rule :colour, "black", "white"
          add_rule :colour, "cat", "dog"
          add_rule :base, "are belong to us"
        end
      end
      
      ex = bad_parse.must_raise Succubus::ParseError
      ex.errors.must_equal_contents ["Duplicate rule definition: colour", "Duplicate rule definition: base"]
    end
    
    it "should fail to execute when rules are missing" do
      grammar = Succubus::Grammar.new do
        add_rule :base, "I have a <size> <colour> <pet>"
        add_rule :colour, "black", "white"
      end
      
      # From ["black", "white"], choose "black"
      expect_random 2, 0
      
      ex = proc {grammar.execute(:base)}.must_raise Succubus::ExecuteError
      ex.errors.must_equal_contents ["No such rule: size", "No such rule: pet"]
      ex.partial.must_equal "I have a !!size!! black !!pet!!"
    end
  end
end