module CollectionSpace

  module Terms
    ::Terms = CollectionSpace::Terms

    #
    # Map keys for terms cache
    #
    AUTHORITIES_CACHE = 'authorities_cache'
    VOCABULARIES = "vocabularies"
    PERSONAUTHORITIES = "personauthorities"

    #
    # Populate vocabularies
    #
    languages = {"english" => "eng", "german" => "deu", "finish" => "fsh"}
    prodpersonrole = { "artist" => "art", "engineer" => "eng"}
    vocabularies = {"languages" => languages, "prodpersonrole" => prodpersonrole}

    #
    # Populate person authorities
    #
    person = { "john muir" => "john_muir", "luke skywalker" => "luke_skywalker"}
    personauthorities = { "person" => person }

    #
    # Use Rails to cache the authorities/vocabularies and terms
    #
    Rails.cache.write(AUTHORITIES_CACHE, { VOCABULARIES => vocabularies, PERSONAUTHORITIES => personauthorities })

    #
    # Pubic accessors to cached vocabularies and terms
    #
    def self.get_vocabularies
      Rails.cache.fetch(AUTHORITIES_CACHE)[VOCABULARIES]
    end

    def self.get_vocabulary(vocabulary_id)
      get_vocabularies[vocabulary_id]
    end

    def self.lookup_vocabulary_term_id(vocabulary_id, display_name)
      get_vocabulary(vocabulary_id)[display_name.downcase]
    end

    #
    # Pubic accessors to cached person authorities and terms
    #
    def self.get_personauthorities
      Rails.cache.fetch(AUTHORITIES_CACHE)[PERSONAUTHORITIES]
    end

    def self.get_person_authority(authority_id)
      get_personauthorities[authority_id]
    end

    def self.lookup_person_term_id(authority_id, display_name)
      get_person_authority(authority_id)[display_name.downcase]
    end

  end

  module Identifiers
    ::CSIDF = CollectionSpace::Identifiers

    def self.authority_term_type(authority)
      authority  = authority.downcase
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
        elements.each { |k, v| xml.send(k.to_sym, v) }
      }
    end

    def self.add_group_list(xml, key, elements = [], sub_key = false, sub_elements = [])
      xml.send("#{key}GroupList".to_sym) {
        elements.each do |element|
          xml.send("#{key}Group".to_sym) {
            element.each { |k, v| xml.send(k.to_sym, v) }
            if sub_key
              xml.send("#{sub_key}SubGroupList".to_sym) {
                sub_elements.each do |sub_element|
                  xml.send("#{sub_key}SubGroup".to_sym) {
                    sub_element.each { |k, v| xml.send(k.to_sym, v) }
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

    def self.get_authority_urn(authority_type, authority_id, value)
      if value
        term_parts = get_term_parts value
        CSURN.generate(
          Rails.application.config.domain,
          term_parts[:authority_type] != nil ? term_parts[:authority_type] : authority_type,
          term_parts[:authority_id] != nil ? term_parts[:authority_id] : authority_id,
          term_parts[:term_id] != nil ? term_parts[:term_id] : CollectionSpace::Identifiers.short_identifier(
              term_parts[:display_name]),
          term_parts[:display_name]
        )
        end
    end

    def self.get_vocab_urn(vocabulary_id, value, strip = false)
      if value
        # try to breakup the term value into component parts
        term_parts = get_term_parts value

        display_name = term_parts[:display_name]
        raise ArgumentError, 'Display name for vocabulary term is missing.' unless display_name != nil

        vocabulary_id = term_parts[:vocabulary_id] != nil ? term_parts[:vocabulary_id] : vocabulary_id
        raise ArgumentError, 'Vocabulary short ID is missing or empty.' unless vocabulary_id != nil

        term_id = term_parts[:term_id]
        if term_id == nil
          term_id = Terms::lookup_vocabulary_term_id vocabulary_id, display_name
        end
        #term_id = CollectionSpace::Identifiers.for_option(term_parts[:display_name], strip)
        raise ArgumentError, 'Vocabulary term does not exist.' unless term_id != nil

        CSURN.generate(
          Rails.application.config.domain,
          "vocabularies",
          vocabulary_id,
          term_id,
          display_name
        )
        end
    end

    #
    # Split a term value into parts -if any.
    #   <authority_type>::<authority_id>::<term_id>::<display_name>
    #   Ex #1: personauthorities::person::john_muir::John Muir
    #   Ex #2: john_muir::John Muir
    #   Ex #3: John Muir
    #
    def split_term(field_value)
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
    def get_term_parts(field_value)
      parts = split_term field_value
      parts_map = { :display_name => parts.pop, :term_id => parts.pop, :authority_id => parts.pop,
                    :authority_type => parts.pop }
    end

  end

  end

end
