module CollectionSpace

  module Identifiers

    # given a vocab option value convert to id form, for example:
    # "Growing on a rock Bonsai style (Seki-joju)" => "growing_on_a_rock_bonsai_style_seki_joju"
    def self.for_option(option)
      option.downcase.
        gsub(/[()]/, '').
        gsub(' - ', '_').
        gsub('-', '_').
        gsub(' ', '_')
    end

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

    def self.add_group(xml, key, elements = {})
      xml.send("#{key}Group".to_sym) {
        elements.each { |k, v| xml.send(k.to_sym, v) }
      }
    end

    def self.add_group_list(xml, key, elements = [])
      xml.send("#{key}GroupList".to_sym) {
        elements.each do |element|
          xml.send("#{key}Group".to_sym) {
            element.each { |k, v| xml.send(k.to_sym, v) }
          }
        end
      }
    end

    def self.add_list(xml, key, elements = [])
      xml.send("#{key}List".to_sym) {
        elements.each do |element|
          xml.send("#{key}".to_sym) {
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

  module Helpers

    def self.add_authority(xml, field, authority_type, authority, value)
      CollectionSpace::XML.add xml, field, CollectionSpace::URN.generate(
        Rails.application.config.domain,
        authority_type,
        authority,
        CollectionSpace::Identifiers.short_identifier(value),
        value
      )
    end

    def self.add_authorities(xml, field, authority_type, authority, values = [], method)
      values = values.map do |value|
        {
          field => CollectionSpace::URN.generate(
            Rails.application.config.domain,
            authority_type,
            authority,
            CollectionSpace::Identifiers.short_identifier(value),
            value
          )
        }
      end
      CollectionSpace::XML.send(method, xml, field, values)
    end

    def self.add_persons(xml, field, values = [], method = :add_group_list)
      add_authorities xml, field, 'personauthorities', 'person', values, method
    end

    def self.add_places(xml, field, values = [], method = :add_group_list)
      add_authorities xml, field, 'placeauthorities', 'place', values, method
    end

    def self.add_taxon(xml, field, value)
      add_authority xml, field, 'taxonomyauthority', 'taxon', value
    end

    def self.add_vocab(xml, field, value)
      CollectionSpace::XML.add xml, field, CollectionSpace::URN.generate(
        Rails.application.config.domain,
        "vocabularies",
        field.downcase,
        CollectionSpace::Identifiers.for_option(value),
        value
      )
    end

  end

  end

end
