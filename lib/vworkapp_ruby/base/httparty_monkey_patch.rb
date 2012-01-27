
## 
# Needed because the extra attributes on the below XML cause httparty to crash: 
#   <jobs type="array" current_page="1" per_page="27" total_pages="1" total_entries="27">
# 
# We probably shouldn't have extra parameters here. Change was:
#   && (v.is_a?(Array) || v.is_a?(Hash))
module MultiXml

  def MultiXml.typecast_xml_value(value)
    case value
    when Hash
      if value['type'] == 'array'
        _, entries = value.detect { |k, v| k != 'type' && (v.is_a?(Array) || v.is_a?(Hash)) }

        if entries.nil? || (entries.is_a?(String) && entries.strip.empty?)
          []
        else
          case entries
          when Array
            entries.map {|entry| typecast_xml_value(entry)}
          when Hash
            [typecast_xml_value(entries)]
          else
            raise "can't typecast #{entries.class.name}: #{entries.inspect}"
          end
        end
      elsif value.has_key?(CONTENT_ROOT)
        content = value[CONTENT_ROOT]
        if block = PARSING[value['type']]
          block.arity == 1 ? block.call(content) : block.call(content, value)
        else
          content
        end
      elsif value['type'] == 'string' && value['nil'] != 'true'
        ''
      # blank or nil parsed values are represented by nil
      elsif value.empty? || value['nil'] == 'true'
        nil
      # If the type is the only element which makes it then
      # this still makes the value nil, except if type is
      # a XML node(where type['value'] is a Hash)
      elsif value['type'] && value.size == 1 && !value['type'].is_a?(Hash)
        nil
      else
        xml_value = value.inject({}) do |hash, (k, v)|
          hash[k] = typecast_xml_value(v)
          hash
        end

        # Turn {:files => {:file => #<StringIO>} into {:files => #<StringIO>} so it is compatible with
        # how multipart uploaded files from HTML appear
        xml_value['file'].is_a?(StringIO) ? xml_value['file'] : xml_value
      end
    when Array
      value.map!{|i| typecast_xml_value(i)}
      value.length > 1 ? value : value.first
    when String
      value
    else
      raise "can't typecast #{value.class.name}: #{value.inspect}"
    end
  end

end