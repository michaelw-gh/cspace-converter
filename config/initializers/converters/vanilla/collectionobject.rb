module CollectionSpace
  module Converter
    module Vanilla
      include Default

      class VanillaCollectionObject < CollectionObject

        def convert
          run do |xml|
            CSXML.add xml, 'objectNumber', attributes["id_number"]
          end
        end

      end

    end
  end
end