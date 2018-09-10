module CollectionSpace
  module Converter
    module OHC

      def self.registered_procedures
        [
          "CollectionObject",
          "Media",
        ]
      end

      def self.registered_profiles
        {
          "cataloging" => {
            "Procedures" => {
              "CollectionObject" => {
                "identifier_field" => "objectNumber",
                "identifier" => "object_number_catalog",
                "title" => "title",
              },
            },
            "Authorities" => {
              "Person" => ["content_person", "inscriber", "objectproductionperson", "owners_person"],
              "Organization" => ["production_org", "owners_org"],
              "Concept" => [["material", "material_ca"]],
            },
            "Relationships" => [
              {
              },
            ],
          },
           "media" => {
             "Procedures" => {
               "Media" => {
                 "identifier_field" => "identificationNumber",
                 "identifier" => "star_system_id",
                 "title" => "star_system_id",
               },
             },
             "Authorities" => {
             },
             "Relationships" => [
               {
                 "procedure1_type" => "CollectionObject",
                 "data1_field" => "object_number_catalog",
                 "procedure2_type" => "Media",
                 "data2_field" => "star_system_id",
               },
             ],
           },

        }
      end

    end
  end
end
