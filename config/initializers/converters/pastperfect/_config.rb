module CollectionSpace
  module Converter
    module PastPerfect

      def self.registered_procedures
        [
          "Acquisition",
          "CollectionObject",
        ]
      end

      def self.registered_profiles
        {
          "ppsaccessiondata" => {
            "Procedures" => {
              "Acquisition" => {
                "identifier_field" => "acquisitionReferenceNumber",
                "identifier" => "accessno",
                "title" => "accessno",
                "service" => "acquisitions",
              }
            },
            "Authorities" => {},
          },
          "ppsobjectsdata" => {
            "Procedures" => {
              "CollectionObject" => {
                "identifier_field" => "objectNumber",
                "identifier" => "objectid",
                "title" => "title",
                "service" => "collectionobjects",
              },
            },
            "Authorities" => {
              "Person" => ["artist"],
            },
          }
        }
      end

    end
  end
end