module CollectionSpace
  module Converter
    module PBM

      def self.registered_procedures
        [
          "Acquisition",
          "CollectionObject",
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
          }
        }
      end

    end
  end
end