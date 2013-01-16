module VWorkApp
  class CustomFieldMobile < Base
    hattr_accessor :type

    def ==(other)
      attributes_eql?(other, :type)
    end
  end

  class CustomField < Base
    hattr_accessor :name, :value, {:mobile => CustomFieldMobile}
    self.include_root_in_json = false

    def initialize(attributes = {})
      mobile_type = attributes.delete(:type)
      super
      self.mobile ||= VWorkApp::CustomFieldMobile.new(type: mobile_type)
    end

    def ==(other)
      attributes_eql?(other, :name, :value, :mobile)
    end

    def type
      self.mobile.type
    end

    def type=(val)
      self.mobile.type = val
    end

  end
end
