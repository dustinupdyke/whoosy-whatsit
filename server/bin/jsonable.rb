class JSONable
    
    def to_json(*a)
      hash = {}
      self.instance_variables.each do |var|
        name = var[1..-1]
        hash[name] = self.instance_variable_get var
      end
      hash.to_json(*a)
    end

    def ref_children
      return self.instance_variables.map { |var| self.instance_variable_get var }
    end

    def declare(&block)
      self.instance_eval &block if block_given?
    end
    
end
