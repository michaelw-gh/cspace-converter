module CollectionSpace
  module Converter
    module PBM
      include Default

      class PBMValuationControl < ValuationControl

        def convert
          run do |xml|
            CollectionSpace::XML.add xml, 'valuationcontrolRefNumber', attributes["valuationcontrolRefNumber"]

            CollectionSpace::XML.add_list xml, 'valueAmounts', [{
              "valueCurrency" => CollectionSpace::URN.generate(
                Rails.application.config.domain,
                "vocabularies",
                "currency",
                # TODO: need to lookup currency short identifiers (this is cheating)
                "USD",
                attributes["valueCurrency"],
              ),
              "valueAmount" => attributes["valueAmount"],
            }]

            CollectionSpace::XML.add xml, 'valueNote', attributes["valueNote"]
          end
        end

      end

    end
  end
end