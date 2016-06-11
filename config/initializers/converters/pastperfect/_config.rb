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
                "identifier" => "accessno",
                "title" => "accessno",
              }
            },
            "Authorities" => {},
          },
          "ppsobjectsdata" => {
            "Procedures" => {
              "CollectionObject" => {
                "identifier" => "objectid",
                "title" => "title",
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