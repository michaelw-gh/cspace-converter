module CollectionSpace
  module Converter
    module Vanilla
      include Default

      class VanillaMaterials < Concept

        def convert
          run do |xml|
            CSXML.add xml, 'shortIdentifier', CSIDF.short_identifier(attributes["materials"])
            CSXML.add xml, 'termDisplayName', attributes["materials"]
            CSXML.add xml, 'description', attributes["definition"]
            CSXML.add xml, 'source', attributes["source"]
          end
        end

      end

    end
  end
end
