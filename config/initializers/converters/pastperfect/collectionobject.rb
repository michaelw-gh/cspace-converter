module CollectionSpace
  module Converter
    module PastPerfect
      include Default

      class PastPerfectCollectionObject < CollectionObject

        def convert
          run do |xml|
            CollectionSpace::XML.add xml, 'objectNumber', attributes["objectid"]
          end
        end

      end

    end
  end
end