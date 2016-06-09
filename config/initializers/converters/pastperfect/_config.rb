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