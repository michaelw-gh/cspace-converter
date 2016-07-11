module CollectionSpace
  module Converter
    module GSBF
      include Default

      class GSBFValuationControl < ValuationControl

        def convert
          run do |xml|
            CollectionSpace::XML.add xml, 'valuationcontrolRefNumber', attributes["valuationControlReferenceNumber"]

            CollectionSpace::XML.add_list xml, 'valueAmounts', [{
              "valueCurrency" => CollectionSpace::URN.generate(
                Rails.application.config.domain,
                "vocabularies",
                "currency",
                # TODO: need to lookup currency short identifiers (this is cheating)
                "USD",
                attributes["valuationCurrency"],
              ),
              "valueAmount" => attributes["valuationAmount"],
            }]
          end
        end

      end

    end
  end
end
