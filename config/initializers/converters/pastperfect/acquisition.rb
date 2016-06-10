module CollectionSpace
  module Converter
    module PastPerfect
      include Default

      class PastPerfectAcquisition < Acquisition

        def convert
          CollectionSpace::XML.add xml, 'acquisitionReferenceNumber', attributes["accessno"]
        end

      end

    end
  end
end