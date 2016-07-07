module CollectionSpace
  module Converter
    module GSBF
      include Default

      class GSBFAcquisition < Acquisition

        def convert
          run do |xml|
            CollectionSpace::XML.add xml, 'acquisitionReferenceNumber', attributes["acquisitionReferenceNumber"]
            CollectionSpace::XML.add xml, 'acquisitionNote', attributes["acquisitionNote"]
            CollectionSpace::XML.add xml, 'creditLine', attributes["acquisitionCreditLine"]

            acq_sources = split_mvf attributes, 'acquisitionSource1', 'acquisitionSource2'
            CollectionSpace::XML::Helpers.add_persons xml, 'acquisitionSources', acq_sources, :add_repeat

            date_periods = split_mvf attributes, 'acquisitionDateEarliest', 'acquisitionDateLatest'
            CollectionSpace::XML.add_group xml, 'acquisitionDate', {
              "dateDisplayDate" => attributes["acquisitionDateDisplayDate"],
              "datePeriod" => date_periods.join("-"),
            }
          end
        end

      end

    end
  end
end
