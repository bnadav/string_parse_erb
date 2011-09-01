require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "StringParseErb" do
  it "does not change a string with no erb fragments" do
    str = "Hello World!"
    string_parse_erb(str, {}).should == "Hello World!"
  end

  it "deletes from string, erb fragments which have no match in the variables hash" do
    str = "Who are <%= person %>"
    string_parse_erb(str, {:man => "you"}).should == "Who are "
  end

  it "replaces erb fragments with values from vars_hash" do
    str = "Good <%= part_of_day %>, the time is <%= time %>."
    vars_hash = {:part_of_day => "morning", :time => "six o'clock"}
    string_parse_erb(str, vars_hash).should == "Good morning, the time is six o'clock."
  end

  it "blocks insecure operations by default ($SAFE level 3)" do
    str = " 1 + 1 = <%= eval(\"1 + 1 \") %>"
    lambda { string_parse_erb(str, {}) }.should raise_error
  end

  it "blocks another insecure operations by default ($SAFE level 3)" do
    lambda { string_parse_erb("<%= abort %>", {}) }.should raise_error
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

  it "Does not untaint if requested" do
    str = "Good <%= part_of_day %>"
    vars_hash = {:part_of_day => "morning"}
    str.taint
    lambda { string_parse_erb(str, vars_hash, 1, false) }.should raise_error
  end

  it "process tainted at SAFE level 0" do
    str = "Good <%= part_of_day %>"
    vars_hash = {:part_of_day => "morning"}
    str.taint
    string_parse_erb(str, vars_hash, 0, false).should == "Good morning"
  end

  it "does not bind external variables" do
    str = "Good <%= part_of_day %>"
    @part_of_day = part_of_day = @@part_of_day = "morning"
    string_parse_erb(str, {}).should == "Good "
  end
end
