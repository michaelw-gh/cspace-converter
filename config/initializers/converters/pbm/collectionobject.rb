module CollectionSpace
  module Converter
    module PBM
      include Default

      class PBMCollectionObject < CollectionObject

        def convert
          run do |xml|
            CollectionSpace::XML.add xml, 'objectNumber', attributes["objectNumber"]
          end
        end

      end

    end
  end
end