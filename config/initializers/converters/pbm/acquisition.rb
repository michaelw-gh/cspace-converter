module CollectionSpace
  module Converter
    module PBM
      include Default

      class PBMAcquisition < Acquisition

        def convert
          run do |xml|
            CollectionSpace::XML.add xml, 'acquisitionReferenceNumber', attributes["acquisitionReferenceNumber"]

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

            CollectionSpace::XML.add xml, 'acquisitionMethod', attributes["acquisitionMethod"]

            CollectionSpace::XML.add_group xml, 'accessionDate', {
              "dateDisplayDate" => attributes["accessionDateDisplayDate"],
              "dateEarliestSingleMonth" => attributes["accessionDateEarliestSingleMonth"],
              "dateEarliestSingleDay" => attributes["accessionDateEarliestSingleDay"],
              "dateEarliestSingleYear" => attributes["accessionDateEarliestSingleYear"],
            }
          end
        end

      end

    end
  end
end