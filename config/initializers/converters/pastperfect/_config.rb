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
            "Acquisition" => {
              "identifier" => "accessno",
              "title" => "accessno",
            }
          },
          "ppsobjectsdata" => {
            "CollectionObject" => {
              "identifier" => "objectid",
              "title" => "title",
            }
          }
        }
      end

    end
  end
end