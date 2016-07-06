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
            acq_sources = acq_sources.map do |source|
              {
                "acquisitionSource" => CollectionSpace::URN.generate(
                  Rails.application.config.domain,
                  "personauthorities",
                  "person",
                  CollectionSpace::Identifiers.short_identifier(source),
                  source,
                ),
              }
            end
            CollectionSpace::XML.add_repeat xml, 'acquisitionSources', acq_sources

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
