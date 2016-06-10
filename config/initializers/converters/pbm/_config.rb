module CollectionSpace
  module Converter
    module PBM

      def self.registered_procedures
        [
          "Acquisition",
          "CollectionObject",
          "ValuationControl",
        ]
      end

      def self.registered_profiles
        {
          "acquisition" => {
            "Acquisition" => {
              "identifier" => "acquisitionReferenceNumber",
              "title" => "acquisitionReferenceNumber",
            }
          },
          "cataloging" => {
            "CollectionObject" => {
              "identifier" => "objectNumber",
              "title" => "title",
            }
          },
          "valuationcontrol" => {
            "ValuationControl" => {
              "identifier" => "valuationcontrolRefNumber",
              "title" => "valuationcontrolRefNumber",
            }
          }
        }
      end

    end
  end
end