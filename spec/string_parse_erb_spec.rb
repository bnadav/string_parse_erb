require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "StringParseErb" do
  it "does not change string with no erb fragments in it" do
    str = "Hello World!"
    string_parse_erb(str, {}).should == "Hello World!"
  end
end
