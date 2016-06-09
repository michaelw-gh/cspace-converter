module CollectionSpace
  module Converter
    module PBM
      include Default

      class PBMCollectionObject < CollectionObject

        def convert
          run do |common|
            CollectionSpace::XML.add common, 'objectNumber', attributes["objectNumber"]
          end
        end

      end

    end
  end
end