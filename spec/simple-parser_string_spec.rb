$:.push('lib')
require 'simple-parser'
include SimpleParser

describe SimpleParser::String do

  describe 'rspec' do

    it "should respond to parse" do
      SimpleParser::String.should respond_to(:parse)
    end

    it "should parse a basic string" do
      SimpleParser::String::parse('this test', ':word1 :word2').should ==(
        { :word1 => 'this', :word2 => 'test' }
      )
    end

    it "should parse a complex string" do
      SimpleParser::String.parse(
        '127.0.0.1 [12/May/2007 00:00:00] "Test Data Here" - - Foo ',
        ':ip [:date] ":description" :attr1 :attr2 :attr3 '
      ).should ==({
        :ip          => '127.0.0.1',
        :date        => '12/May/2007 00:00:00',
        :description => 'Test Data Here',
        :attr1       => '-',
        :attr2       => '-',
        :attr3       => 'Foo'
      })
    end

    it "should be includable on strings" do
      class String; include SimpleParser::String; end

      'this test'.parse(':word1 :word2').should == (
        { :word1 => 'this', :word2 => 'test' }
      )
    end

    it "should be able to ignore tokens" do
      SimpleParser::String.parse('this bad test', ':word1 :: :word2').should == (
        { :word1 => 'this', :word2 => 'test' }
      )
    end

  end

end