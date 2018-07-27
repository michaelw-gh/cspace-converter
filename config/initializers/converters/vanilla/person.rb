module CollectionSpace
  module Converter
    module Vanilla
      include Default

      class VanillaPerson < Person

        def convert
          run do |xml|
            CSXML.add xml, 'shortIdentifier', CSIDF.short_identifier(attributes["name"])
            CSXML.add xml, 'termDisplayName', attributes["name"]
            CSXML.add xml, 'termType', "#{CSIDF.authority_term_type('Person')}Term"
            CSXML.add xml, 'hello', 'world'
          end
        end

      end

    end
  end
end
