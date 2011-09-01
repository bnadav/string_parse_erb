module StrParseErb

   def string_parse_erb(template, var_hash, safe_level=4)
     data = VarHash.new(var_hash)
     ERB.new(template, safe_level).result(data.get_binding.taint)
   end

   class VarHash < OpenStruct
     def get_binding
       binding
     end
   end

end
