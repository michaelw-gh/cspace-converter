module CollectionSpace
  module Converter
    module AuthCache
      ::AuthCache = CollectionSpace::Converter::AuthCache

      #
      # Map key constants for terms cache
      #
      AUTHORITIES_CACHE = 'authorities_cache'
      VOCABULARIES = "vocabularies"
      PERSONAUTHORITIES = "personauthorities"

      #
      # Pubic accessors to cached vocabularies and terms
      #
      def self.get_vocabularies
        Rails.cache.fetch(AuthCache::AUTHORITIES_CACHE)[AuthCache::VOCABULARIES]
      end

      def self.get_vocabulary(vocabulary_id)
        get_vocabularies[vocabulary_id]
      end

      def self.set_vocabulary(vocabulary_id, terms)
        get_vocabularies[vocabulary_id] = terms
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

  end
end