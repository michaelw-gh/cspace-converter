module CollectionSpace
  module Converter
    module PBM
      include Default

      class PBMConservation < Conservation

        def convert
          run(wrapper: "document") do |xml|
            xml.send(
              "ns2:conservation_common",
              "xmlns:ns2" => "http://collectionspace.org/services/conservation",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil

              CollectionSpace::XML.add xml, 'conservationNumber', attributes["conservationNumber"]

              # date (3/11/1999 - MDY)
              date = attributes["treatmentStartDate"]
              if date
                treatmentStartDate = Date.strptime(
                  date, '%m/%d/%Y'
                ).to_s << "T00:00:00.000Z"
                CollectionSpace::XML.add xml, 'treatmentStartDate', treatmentStartDate
              end
            end

            xml.send(
              "ns2:conservation_bonsai",
              "xmlns:ns2" => "http://collectionspace.org/services/conservation/local/bonsai",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil

              CollectionSpace::XML.add_repeat xml, 'treatmentsPerformed', [{
                "treatmentPerformed" => CollectionSpace::URN.generate(
                  Rails.application.config.domain,
                  "vocabularies",
                  "treatmentperformed",
                  attributes["treatmentPerformed"].downcase,
                  attributes["treatmentPerformed"].capitalize
                ),
              }]
            end

          end
        end

      end

    end
  end
end