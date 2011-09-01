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

  it "replaces erb fragments with values from vars_hash, when string is tainted" do
    str = "Good <%= part_of_day %>, the time is <%= time %>."
    vars_hash = {:part_of_day => "morning", :time => "six o'clock"}
    string_parse_erb(str.taint, vars_hash).should == "Good morning, the time is six o'clock."
  end

  it "blocks insecure operations by default" do
    str = "<%= eval(\"system('ls')\") %>"
    lambda { string_parse_erb(str, {}) }.should raise_error(SecurityError)
  end

  it "blocks another insecure operations by default" do
    lambda { string_parse_erb("<%= abort %>", {}) }.should raise_error(SecurityError)
  end

  it "blocks insecure operations by default, when string is tainted" do
    str = "<%= eval(\"system('ls')\") %>"
    lambda { string_parse_erb(str.taint, {}) }.should raise_error(SecurityError)
  end

  it "allows changing SAFE level" do
    str = " 1 + 1 = <%= eval(\"1 + 1 \") %>"
    string_parse_erb(str, {}, 0).should == " 1 + 1 = 2"
  end

  it "does not bind external variables" do
    str = "Good <%= part_of_day %>"
    @part_of_day = part_of_day = @@part_of_day = "morning"
    string_parse_erb(str, {}).should == "Good "
  end

  it "processes complex fragments" do
    str = "Hello<% if planet %> planet <% else %> earth <% end %>"
    string_parse_erb(str, {:planet => false}).should == "Hello earth "
  end
end
