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
   def string_parse_erb(template, vars_hash)
     template
   end
  end # InstanceMethods

end
