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
                "identifier" => "acquisitionReferenceNumber",
                "title" => "acquisitionReferenceNumber",
              }
            },
            "Authorities" => {
              "Person" => ["acquisitionSource1", "acquisitionSource2"],
            },
          },
          "cataloging" => {
            "Procedures" => {
              "CollectionObject" => {
                "identifier" => "objectNumber",
                "title" => "title",
              }
            },
            "Authorities" => {
              "Person" => ["objectProductionPerson1"],
            },
          },
          "conservation" => {
            "Procedures" => {
              "Conservation" => {
                "identifier" => "conservationNumber",
                "title" => "conservationNumber",
              }
            },
            "Authorities" => {},
          },
          "valuationcontrol" => {
            "Procedures" => {
              "ValuationControl" => {
                "identifier" => "valuationcontrolRefNumber",
                "title" => "valuationcontrolRefNumber",
              }
            },
            "Authorities" => {},
          }
        }
      end

    end
  end
end