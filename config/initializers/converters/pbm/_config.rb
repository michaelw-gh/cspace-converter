module CollectionSpace
  module Converter
    module PBM

      def self.registered_procedures
        [
          "Acquisition",
          "CollectionObject",
          "Conservation",
          "ValuationControl",
        ]
      end

      def self.registered_profiles
        {
          "acquisition" => {
            "Procedures" => {
              "Acquisition" => {
                "identifier_field" => "acquisitionReferenceNumber",
                "identifier" => "acquisitionReferenceNumber",
                "title" => "acquisitionReferenceNumber",
                # "service" => "acquisitions", DEPRECATED
              }
            },
            "Authorities" => {
              "Person" => ["acquisitionSource1", "acquisitionSource2"],
            },
            "Relationships" => [
              {
                "procedure1_type"  => "Acquisition",
                "procedure1_field" => "acquisitionReferenceNumber",
                "procedure2_type"  => "CollectionObject",
                "procedure2_field" => "objectNumber",
              },
            ],
          },
          "cataloging" => {
            "Procedures" => {
              "CollectionObject" => {
                "identifier_field" => "objectNumber",
                "identifier" => "objectNumber",
                "title" => "title",
                # "service" => "collectionobjects", DEPRECATED
              }
            },
            "Authorities" => {
              "Person" => ["objectProductionPerson1"],
              "Place"  => ["objectProductionPlace1"],
              "Taxon"  => ["taxon"],
            },
          },
          "conservation" => {
            "Procedures" => {
              "Conservation" => {
                "identifier_field" => "conservationNumber",
                "identifier" => "conservationNumber",
                "title" => "conservationNumber",
                # "service" => "conservation", DEPRECATED
              }
            },
            "Authorities" => {},
          },
          "valuationcontrol" => {
            "Procedures" => {
              "ValuationControl" => {
                "identifier_field" => "valuationcontrolRefNumber",
                "identifier" => "valuationcontrolRefNumber",
                "title" => "valuationcontrolRefNumber",
                # "service" => "valuationcontrols", DEPRECATED
              }
            },
            "Authorities" => {},
          }
        }
      end

    end
  end
end