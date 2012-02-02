require 'set'

module VWorkApp
  class Base
    include ActiveModel::Serializers::JSON
    include ActiveModel::Serializers::Xml
    include ActiveModel::Validations

    def initialize(attributes = {})
      self.attributes = attributes
    end

    # -----------------
    # Hattr Methods
    # ----------------

    def self.hattr_reader(*hattrs)
      hattrs.each do |hattr|
        self.read_hattrs << hattr
        attr_reader(hattr.is_a?(Hash) ? hattr.keys.first : hattr)
      end
    end

    def self.hattr_writer(*hattrs)
      hattrs.each do |hattr|
        self.write_hattrs << hattr
        attr_writer(hattr.is_a?(Hash) ? hattr.keys.first : hattr)
      end
    end
    
    def self.hattr_accessor(*hattrs)
      hattr_reader(*hattrs)
      hattr_writer(*hattrs)
    end

    def self.write_hattrs
      @write_hattrs ||= Set.new
    end
    def write_hattrs
      self.class.write_hattrs
    end

    def self.read_hattrs
      @read_hattrs ||= Set.new
    end
    def read_hattrs
      self.class.read_hattrs
    end

    def self.hattrs
      read_hattrs + write_hattrs
    end
    def hattrs
      self.class.hattrs
    end

    # -------------------
    # Attributes Methods
    # -------------------
  
    def attributes
      extract_attributes(hattrs)
    end

    def read_attributes
      extract_attributes(read_hattrs)
    end
    
    def write_attributes
      extract_attributes(write_hattrs)
    end

    def attributes=(hash)
      inject_attributes(hattrs, hash)
    end

    def write_attributes=(hash)
      inject_attributes(write_hattrs, hash)
    end

    def read_attributes=(hash)
      inject_attributes(read_hattrs, hash)
    end

    # -----------------
    # Misc Methods
    # -----------------

    def validate_and_raise
      raise Exception.new(self.errors.full_messages.join("\n")) unless valid?
    end

    def attributes_eql?(other, *test_attrs)
      test_attrs.each do |attribute|
        return false unless self.send(attribute.to_sym) == other.send(attribute.to_sym)
      end
      true
    end

  private
      
    def extract_attributes(hattrs)
      attr = hattrs.map do |hattr|
        hattr = hattr.keys.first if hattr.is_a?(Hash)
        [hattr.to_s, send(hattr)]
      end
      Hash[attr]
    end

    def inject_attributes(hattrs, hash)
      hash = Hash[hash.map { |k,v| [k.to_sym, v] }]

      hattrs.each do |hattr|
        value = case hattr
        when Hash
          hattr, klass = hattr.first
          next unless hash[hattr.to_sym]
          klass.is_a?(Array) ? hash[hattr.to_sym].map {|h| klass.first.new(h)} : klass.new(hash[hattr.to_sym])
        else
          next unless hash[hattr.to_sym]
          hash[hattr.to_sym]
        end
        
        set_hattr(hattr, value)
      end
    end

    def set_hattr(hattr, value)
      write_hattrs.include?(hattr) ? send("#{hattr}=", value) : self.instance_variable_set("@#{hattr.to_s}", value)
    end

  end
end

# -----------------
# AM Monkey Patches. Yuk.
# -----------------

module ActiveModel::Serialization
  def serializable_hash(options = nil)
    options ||= {}

    only   = Array.wrap(options[:only]).map(&:to_s)
    except = Array.wrap(options[:except]).map(&:to_s)

    # AF: Changed to write_attributes
    attribute_names = write_attributes.keys.sort
    if only.any?
      attribute_names &= only
    elsif except.any?
      attribute_names -= except
    end

    method_names = Array.wrap(options[:methods]).map { |n| n if respond_to?(n.to_s) }.compact
    Hash[(attribute_names + method_names).map { |n| [n, send(n)] }]
  end
end

module ActiveModel::Serializers::Xml
  class Serializer
    def attributes_hash
      # AF: Changed to write_attributes
      attributes = @serializable.write_attributes
      if options[:only].any?
        attributes.slice(*options[:only])
      elsif options[:except].any?
        attributes.except(*options[:except])
      else
        attributes
      end
    end
  end
end
