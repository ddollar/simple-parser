$:.push('lib')
require 'simple-parser'
include SimpleParser

describe SimpleParser do
  
  describe 'rspec' do

    it "should have a version" do
      lambda { SimpleParser.version }.should_not raise_error
    end
    
    it "should have a libpath" do
      lambda { SimpleParser.libpath }.should_not raise_error
    end
    
    it "should have a path" do
      lambda { SimpleParser.path }.should_not raise_error
    end

  end
  
end