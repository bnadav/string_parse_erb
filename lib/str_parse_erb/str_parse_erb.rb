module StrParseErb

   def string_parse_erb(template, vars_hash, safe_level=4)
     data = OpenStruct.new(vars_hash)
     ERB.new(template, safe_level).result(data.send(:binding).taint)
   end

end
