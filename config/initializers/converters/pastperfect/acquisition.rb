module CollectionSpace
  module Converter
    module PastPerfect
      include Default

      class PastPerfectAcquisition < Acquisition

        def convert
          run do |xml|
            CollectionSpace::XML.add xml, 'acquisitionReferenceNumber', attributes["accessno"]
          end
        end

      end

    end
  end
end