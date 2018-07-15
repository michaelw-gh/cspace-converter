module CollectionSpace

  module Identifiers
    ::CSIDF = CollectionSpace::Identifiers

    def self.authority_term_type(authority)
      authority = authority.downcase
      # not all authorities use the full name in the term type i.e. orgTermGroupList
      term_types = {
          "location" => "loc",
          "organization" => "org",
      }
      term_types.fetch(authority, authority)
    end

    # given a vocab option value convert to id form, for example:
    # "Growing on a rock Bonsai style (Seki-joju)" => "growing_on_a_rock_bonsai_style_seki_joju"
    def self.for_option(option, strip = false)
      option = option.strip if strip
      option.downcase.
          gsub(/[()'"]/, '').
          gsub(' - ', '_').
          gsub('/', '_').
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
    ::CSURN = CollectionSpace::URN

    def self.generate(domain, type, sub, identifier, label)
      "urn:cspace:#{domain}:#{type}:name(#{sub}):item:name(#{identifier})'#{label}'"
    end
  end

  class XML
    ::CSXML = CollectionSpace::XML

    def self.add(xml, key, value)
      xml.send(key.to_sym, value)
    end

    def self.add_group(xml, key, elements = {})
      xml.send("#{key}Group".to_sym) {
        elements.each {|k, v| xml.send(k.to_sym, v)}
      }
    end

    def self.add_group_list(xml, key, elements = [], sub_key = false, sub_elements = [])
      xml.send("#{key}GroupList".to_sym) {
        elements.each do |element|
          xml.send("#{key}Group".to_sym) {
            element.each {|k, v| xml.send(k.to_sym, v)}
            if sub_key
              xml.send("#{sub_key}SubGroupList".to_sym) {
                sub_elements.each do |sub_element|
                  xml.send("#{sub_key}SubGroup".to_sym) {
                    sub_element.each {|k, v| xml.send(k.to_sym, v)}
                  }
                end
              }
            end
          }
        end
      }
    end

    def self.add_nogroup_list(xml, key, elements = [], sub_key = false, sub_elements = [])
      xml.send("#{key}List".to_sym) {
        elements.each do |element|
          xml.send("#{key}Group".to_sym) {
            element.each {|k, v| xml.send(k.to_sym, v)}
            if sub_key
              xml.send("#{sub_key}SubGroupList".to_sym) {
                sub_elements.each do |sub_element|
                  xml.send("#{sub_key}SubGroup".to_sym) {
                    sub_element.each {|k, v| xml.send(k.to_sym, v)}
                  }
                end
              }
            end
          }
        end
      }
    end

    # key_suffix handles the case that the list child element is not the key without "List"
    # for example: key=objectName, list=objectNameList, key_suffix=Group, child=objectNameGroup
    def self.add_list(xml, key, elements = [], key_suffix = '')
      xml.send("#{key}List".to_sym) {
        elements.each do |element|
          xml.send("#{key}#{key_suffix}".to_sym) {
            element.each {|k, v| xml.send(k.to_sym, v)}
          }
        end
      }
    end

    def self.add_repeat(xml, key, elements = [])
      xml.send(key.to_sym) {
        elements.each do |element|
          element.each {|k, v| xml.send(k.to_sym, v)}
        end
      }
    end

    def self.add_string(xml, string)
      xml << string
    end

    module Helpers

      def self.add_authority(xml, field, authority_type, authority, value)
        CSXML.add xml, field, get_authority_urn(authority_type, authority, value)
      end

      def self.add_authorities(xml, field, authority_type, authority, values = [], method)
        values = values.map do |value|
          {
              field => get_authority_urn(authority_type, authority, value),
          }
        end
        # we are crudely forcing pluralization for repeats (this may need to be revisited)
        # sometimes the parent and child elements are both pluralized so ensure there's only 1 i.e.
        # conservators: [ "conservators" ... ] vs. acquisitionSources: [ "acquisitionSource" ... ]
        field_wrapper = method == :add_repeat ? "#{field}s".gsub(/ss$/, "s") : field
        CSXML.send(method, xml, field_wrapper, values)
      end

      def self.add_concept(xml, field, value)
        add_authority xml, field, 'conceptauthorities', 'concept', value
      end

      def self.add_concepts(xml, field, values = [], method = :add_group_list)
        add_authorities xml, field, 'conceptauthorities', 'concept', values, method
      end

      def self.add_location(xml, field, value)
        add_authority xml, field, 'locationauthorities', 'location', value
      end

      def self.add_locations(xml, field, values = [], method = :add_group_list)
        add_authorities xml, field, 'locationauthorities', 'location', values, method
      end

      def self.add_person(xml, field, value)
        add_authority xml, field, 'personauthorities', 'person', value
      end

      def self.add_persons(xml, field, values = [], method = :add_group_list)
        add_authorities xml, field, 'personauthorities', 'person', values, method
      end

      def self.add_organization(xml, field, value)
        add_authority xml, field, 'orgauthorities', 'organization', value
      end

      def self.add_organizations(xml, field, values = [], method = :add_group_list)
        add_authorities xml, field, 'orgauthorities', 'organization', values, method
      end

      def self.add_place(xml, field, value)
        add_authority xml, field, 'placeauthorities', 'place', value
      end

      def self.add_places(xml, field, values = [], method = :add_group_list)
        add_authorities xml, field, 'placeauthorities', 'place', values, method
      end

      def self.add_taxon(xml, field, value)
        add_authority xml, field, 'taxonomyauthority', 'taxon', value
      end

      # NOTE: assumes field name matches vocab name (may need to update)
      def self.add_vocab(xml, field, value)
        CSXML.add xml, field, get_vocab_urn(field, value)
      end


      #
      # Split a term value into parts -if any.
      #   <authority_type>::<authority_id>::<term_id>::<display_name>
      #   Ex #1: personauthorities::person::john_muir::John Muir
      #   Ex #2: john_muir::John Muir
      #   Ex #3: John Muir
      #
      def self.split_term(field_value)
        values = []
        values << field_value
                      .to_s
                      .split("::")
                      .map(&:strip)
        values.flatten.compact
      end

      #
      # Add split a term value into parts and add to a map
      #
      def self.get_term_parts(field_value)
        parts = split_term field_value
        parts_map = {:display_name => parts.pop, :term_id => parts.pop, :authority_id => parts.pop,
                     :authority_type => parts.pop}
      end

      #
      # Get (or create) a URN for an authority term value
      #
      def self.get_authority_urn(authority_type, authority_id, value)
        if value
          term_parts = get_term_parts value

          display_name = term_parts[:display_name]
          raise ArgumentError, 'Display name for authority term is missing.' unless display_name != nil

          authority_id = term_parts[:authority_id] != nil ? term_parts[:authority_id] : authority_id
          raise ArgumentError, 'Authority short ID is missing or empty.' unless authority_id != nil

          term_id = term_parts[:term_id]
          if term_id == nil
            term_id = AuthCache::lookup_authority_term_id authority_type, authority_id, display_name
          end

          #
          # If the caller didn't supply a short ID and we couldn't find an existing one then
          # we need to create one.
          #
          if term_id == nil
            term_id = CollectionSpace::Identifiers.short_identifier(display_name)
          end

          CSURN.generate(
              Rails.application.config.domain,
              authority_type,
              authority_id,
              term_id,
              display_name
          )
        end
      end

      #
      # Get the URN for a vocabulary term value
      #
      def self.get_vocab_urn(vocabulary_id, value, row_number = "unknown", strip = false)
        if value
          # try to breakup the term value into component parts
          term_parts = get_term_parts value

          display_name = term_parts[:display_name]
          raise ArgumentError, 'Display name for vocabulary term is missing.' unless display_name != nil

          vocabulary_id = term_parts[:authority_id] != nil ? term_parts[:authority_id] : vocabulary_id
          raise ArgumentError, 'Vocabulary short ID is missing or empty.' unless vocabulary_id != nil

          term_id = term_parts[:term_id]
          if term_id == nil
            term_id = AuthCache::lookup_vocabulary_term_id vocabulary_id, display_name
          end
          Rails.logger.error "Problem in row #{row_number} because vocabulary short ID for term '#{display_name}' does not exist or was not provided." unless term_id != nil

          CSURN.generate(
              Rails.application.config.domain,
              AuthCache::VOCABULARIES,
              vocabulary_id,
              term_id,
              display_name
          )
        end
      end

    end

  end

end
