module CollectionSpace
  module Converter
    module GSBF
      include Default

      class GSBFConservation < Conservation

        def convert
          run(wrapper: "document")  do |xml|
            xml.send(
              "ns2:conservation_common",
              "xmlns:ns2" => "http://collectionspace.org/services/conservation",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              CSXML.add xml, 'conservationNumber', attributes["conservationNumber"]

              treatment_start_date = DateTime.parse(attributes["treatmentStartDate"]) rescue nil
              CSXML.add xml, 'treatmentStartDate', treatment_start_date if treatment_start_date

              if attributes.fetch("conservators", nil)
                conservators = split_mvf attributes, 'conservators'
                CSXML::Helpers.add_persons xml, 'conservators', conservators, :add_repeat
              end

              CSXML.add xml, 'treatmentSummary', attributes['treatmentSummary']
            end

            xml.send(
              "ns2:conservation_bonsai",
              "xmlns:ns2" => "http://collectionspace.org/services/conservation/local/bonsai",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil

              CSXML.add_group_list xml, 'futureTreatment', [{
                "futureTreatmentNote" => attributes["futureTreatmentNote"],
              }]
            end

            xml.send(
              "ns2:conservation_livingplant",
              "xmlns:ns2" => "http://collectionspace.org/services/conservation/domain/livingplant",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              CSXML::Helpers.add_person xml, 'performedBy', split_mvf(attributes, 'performedBy')[0] if attributes["performedBy"]

              date_repotted = DateTime.parse(attributes["dateRepotted"]) rescue nil
              CSXML.add xml, 'dateRepotted', date_repotted
              CSXML.add xml, 'description', attributes["description"]
              CSXML.add xml, 'plannedTreatment', attributes["plannedTreatment"]

              next_repotting = DateTime.parse(attributes["nextRepotting"]) rescue nil
              CSXML.add xml, 'nextRepotting', next_repotting

              observed = attributes["pestOrDiseaseObserved"].nil? ?
                nil : CSXML::Helpers.get_vocab_urn('pestOrDiseaseObserved', attributes["pestOrDiseaseObserved"])

              date_observed = DateTime.parse(attributes["dateObserved"]) rescue nil

              identified_by = attributes["identifiedBy"].nil? ?
                nil : CSXML::Helpers.get_authority_urn('personauthorities', 'person', split_mvf(attributes, 'identifiedBy')[0])

              treated_by = attributes["treatedBy"].nil? ?
                nil : CSXML::Helpers.get_authority_urn('personauthorities', 'person', split_mvf(attributes, 'treatedBy')[0])

              treatment_date = DateTime.parse(attributes["treatmentDate"]) rescue nil

              CSXML.add_group_list xml, 'pestsAndDisease', [{
                "pestOrDiseaseObserved" => observed,
                "dateObserved"          => date_observed,
                "identifiedBy"          => identified_by,
                "treatedWith"           => attributes["treatedWith"],
                "treatedBy"             => treated_by,
                "treatmentDate"         => treatment_date,
                "futureTreatmentNotes"  => attributes["futureTreatmentNotes"],
              }]

              application_date = DateTime.parse(attributes["applicationDate"]) rescue nil

              applied_by = attributes["appliedBy"].nil? ?
                nil : CSXML::Helpers.get_authority_urn('personauthorities', 'person', split_mvf(attributes, 'appliedBy')[0])

              CSXML.add_group_list xml, 'fertilization', [{
                "applicationDate"    => application_date,
                "appliedBy"          => applied_by,
                "fertilizationNotes" => attributes["fertilizationNotes"]
              }]
            end
          end
        end

      end

    end
  end
end
