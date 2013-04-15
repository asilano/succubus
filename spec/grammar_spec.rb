require 'coveralls'
Coveralls.wear! do
	add_filter '/test/'
	add_filter '/spec/'
	add_filter '/examples/'
end
require 'minitest/autorun'
require File.dirname(__FILE__) + '/../test/support/fixed_random'
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
      expect_sample ["I have a <colour> <pet>", "<pet>s look best in <colour>"], "<pet>s look best in <colour>"
      expect_sample ["cat", "dog"], "cat"
      expect_sample ["black", "white"], "black"
      
      @grammar.execute(:base).must_equal "cats look best in black"
      
      samples_must_be_used
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
      ex.errors.must_have_same_elements_as ["Duplicate rule definition: colour", "Duplicate rule definition: base"]
    end
    
    it "should fail to execute when rules are missing" do
      grammar = Succubus::Grammar.new do
        add_rule :base, "I have a <size> <colour> <pet>"
        add_rule :colour, "black", "white"
      end
      
      expect_sample %w<black white>, "black"
      
      ex = proc {grammar.execute(:base)}.must_raise Succubus::ExecuteError
      ex.errors.must_have_same_elements_as ["No such rule: size", "No such rule: pet"]
      ex.partial.must_equal "I have a !!size!! black !!pet!!"
    end
  end
end