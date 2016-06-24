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
              }
            },
            "Authorities" => {
              "Person" => ["objectProductionPerson1"],
              "Place"  => ["objectProductionPlace1"],
              "Taxon"  => ["taxon"],
            },
            "Relationships" => [],
          },
          "conservation" => {
            "Procedures" => {
              "Conservation" => {
                "identifier_field" => "conservationNumber",
                "identifier" => "conservationNumber",
                "title" => "conservationNumber",
              }
            },
            "Authorities" => {},
            "Relationships" => [
              {
                "procedure1_type"  => "Conservation",
                "procedure1_field" => "conservationNumber",
                "procedure2_type"  => "CollectionObject",
                "procedure2_field" => "objectNumber",
              },
            ],
          },
          "valuationcontrol" => {
            "Procedures" => {
              "ValuationControl" => {
                "identifier_field" => "valuationcontrolRefNumber",
                "identifier" => "valuationcontrolRefNumber",
                "title" => "valuationcontrolRefNumber",
              }
            },
            "Authorities" => {},
            "Relationships" => [
              {
                "procedure1_type"  => "ValuationControl",
                "procedure1_field" => "valuationcontrolRefNumber",
                "procedure2_type"  => "CollectionObject",
                "procedure2_field" => "objectNumber",
              },
            ],
          }
        }
      end

    end
  end
end