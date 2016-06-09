module CollectionSpace
  module Converter
    module PBM

      def self.registered_procedures
        [
          "CollectionObject",
        ]
      end

      def self.registered_profiles
        {
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