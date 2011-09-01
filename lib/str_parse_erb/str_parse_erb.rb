module StrParseErb

   def string_parse_erb(template, vars_hash, safe_level=3, untaint = true)
     template.untaint if untaint and template.tainted?
     data = OpenStruct.new(vars_hash)
     ERB.new(template, safe_level).result(data.send(:binding))
   end

end
