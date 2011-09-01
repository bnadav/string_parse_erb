require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "StringParseErb" do
  it "does not change a string with no erb fragments" do
    str = "Hello World!"
    string_parse_erb(str, {}).should == "Hello World!"
  end

  it "replaces erb fragments with values from vars_hash" do
    str = "Good <%= part_of_day %>"
    vars_hash = {:part_of_day => "morning"}
    string_parse_erb(str, vars_hash).should == "Good morning"
  end

  it "blocks unsecure operations by default ($SAFE level 3)" do
    str = " 1 + 1 = <%= eval(\"1 + 1 \") %>"
    lambda { string_parse_erb(str, {}) }.should raise_error
  end

  it "allows changing SAFE level" do
    str = " 1 + 1 = <%= eval(\"1 + 1 \") %>"
    string_parse_erb(str, {}, 0).should == " 1 + 1 = 2"
  end

  it "Untaints string by default in order to process external strings" do
    str = "Good <%= part_of_day %>"
    vars_hash = {:part_of_day => "morning"}
    str.taint
    string_parse_erb(str, vars_hash).should == "Good morning"
  end

end
