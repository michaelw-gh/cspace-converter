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
          "accessions" => {
            "Procedures" => {
              "Acquisition" => {
                "identifier_field" => "acquisitionReferenceNumber",
                "identifier" => "accessno",
                "title" => "accessno",
              }
            },
            "Authorities" => {},
            "Relationships" => [],
          },
          "objects" => {
            "Procedures" => {
              "CollectionObject" => {
                "identifier_field" => "objectNumber",
                "identifier" => "objectid",
                "title" => "title",
              },
            },
            "Authorities" => {
              "Person" => ["artist"],
            },
            "Relationships" => [
              {
                "procedure1_type"  => "Acquisition",
                "procedure1_field" => "accessno",
                "procedure2_type"  => "CollectionObject",
                "procedure2_field" => "objectid",
              },
            ],
          }
        }
      end

    end
  end
end