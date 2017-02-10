module CollectionSpace
  module Converter
    module Vanilla

      def self.registered_procedures
        [
          "CollectionObject",
        ]
      end

      def self.registered_profiles
        {
          "cataloging" => {
            "Procedures" => {
              "CollectionObject" => {
                "identifier_field" => "objectNumber",
                "identifier" => "id_number",
                "title" => "id_number",
              },
            },
            "Authorities" => {
              "Person" => ["Content Person"],
            },
            "Relationships" => [], # nothing to see here!
          }
        }
      end

    end
  end
end