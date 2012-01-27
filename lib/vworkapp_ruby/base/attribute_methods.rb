module VWorkApp
  module AttributeMethods
    
    def self.included(base)
      base.extend(ClassMethods)
    end

    def to_hash
      hash = {}
      self.attributes.each do |attribute|
        case attribute
        when Hash
          attribute, klass = attribute.shift
          next unless obj = self.send(attribute)
          hash[attribute.to_sym] = obj.is_a?(Array) ? obj.map {|o| o.to_hash} : obj.to_hash
        else
          next unless value = self.send(attribute)
          hash[attribute.to_sym] = value
        end
      end
      hash
    end

    def attributes_eql?(other, attributes)
      attributes.each do |attribute|
        return false unless self.send(attribute.to_sym) == other.send(attribute.to_sym)
      end
      true
    end

    module ClassMethods
      def from_hash(hash)
        hash = Hash[hash.map { |k,v| [k.to_sym, v] }]

        instance = self.allocate
        something_set = false

        instance.attributes.each do |attribute|
          value = case attribute
          when Hash
            attribute, klass = attribute.shift
            next unless hash[attribute.to_sym]
            klass.is_a?(Array) ? hash[attribute.to_sym].map {|h| klass.first.from_hash(h)} : klass.from_hash(hash[attribute.to_sym])
          else
            next unless hash[attribute.to_sym]
            hash[attribute.to_sym]
          end

          something_set = true
          instance.instance_variable_set("@#{attribute.to_s}", value)
        end
        
        something_set ? instance : nil
      end
    end

  end
end