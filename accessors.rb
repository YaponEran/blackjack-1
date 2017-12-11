module Accessors
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def attr_accessor_with_history(*params)
      params.each do |param|
        define_method(param) do
          instance_variable_get("@#{param}")
        end
        define_method("#{param}_history") do
          instance_variable_get("@#{param}_history")
        end
        define_method("#{param}=") do |value|
          instance_variable_set("@#{param}", value)
          history_values = instance_variable_get("@#{param}_history") || {}
          history_values[value] ||= {count: 0, first_exec: Time.now}
          history_values[value][:count] += 1  
          history_values[value][:last_exec] = Time.now
          instance_variable_set("@#{param}_history", history_values)
        end
      end
    end
  end
end
