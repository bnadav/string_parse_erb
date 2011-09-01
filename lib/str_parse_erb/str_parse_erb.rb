module StrParseErb

  def self.included(base)
    base.extend         ClassMethods
    base.class_eval do

    end
    base.send :include, InstanceMethods
  end # self.included

  module ClassMethods

  end # ClassMethods

  module InstanceMethods
   def string_parse_erb(template, vars_hash, safe_level=3, untaint = true)
     template.untaint if untaint and template.tainted?
     data = OpenStruct.new(vars_hash)
     ERB.new(template, safe_level).result(data.send(:binding))
   end
  end # InstanceMethods


end
