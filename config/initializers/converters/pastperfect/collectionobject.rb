module CollectionSpace
  module Converter
    module PastPerfect
      include Default

      class PastPerfectCollectionObject < CollectionObject

        def convert
          run do |common|
            CollectionSpace::XML.add common, 'objectNumber', attributes["objectid"]
          end
        end

      end

    end
  end
end