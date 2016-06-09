module CollectionSpace

  module Identifiers
    def self.short_identifier(value)
      v_str = value.gsub(/\W/, ''); # remove non-words
      v_enc = Base64.strict_encode64(v_str); # encode it
      v = v_str + v_enc.gsub(/\W/, ''); # remove non-words from result
      v
    end
  end

  module URN
    def self.generate(domain, type, sub, identifier, label)
      "urn:cspace:#{domain}:#{type}:name(#{sub}):item:name(#{identifier})'#{label}'"
    end
  end

  class XML

    def self.add(xml, key, value)
      xml.send(key.to_sym, value)
    end

    def self.add_group(xml, key, elements = [])
      xml.send("#{key}GroupList".to_sym) {
        elements.each do |element|
          xml.send("#{key}Group".to_sym) {
            element.each { |k, v| xml.send(k.to_sym, v) }
          }
        end
      }
    end

    def self.add_repeat(xml, key, elements = [])
      xml.send(key.to_sym) {
        elements.each do |element|
          element.each { |k, v| xml.send(k.to_sym, v) }
        end
      }
    end

  end

end