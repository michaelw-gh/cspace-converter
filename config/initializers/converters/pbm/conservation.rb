module CollectionSpace
  module Converter
    module PBM
      include Default

      class PBMConservation < Conservation

        def convert
          run do |xml|
            CollectionSpace::XML.add xml, 'conservationNumber', attributes["conservationNumber"]
          end
        end

      end

    end
  end
end