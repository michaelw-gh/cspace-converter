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
                # "service" => "acquisitions", DEPRECATED
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
                # "service" => "collectionobjects", DEPRECATED
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