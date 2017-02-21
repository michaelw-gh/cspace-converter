module CollectionSpace
  module Converter
    module Vanilla
      include Default

      class VanillaCollectionObject < CollectionObject

        def convert
          run do |xml|
            CSXML.add xml, 'objectNumber', attributes["id_number"]

            CSXML.add xml, 'numberOfObjects', attributes["number_of_objects"]

            CSXML.add_group_list xml, 'title', [{
            "title" => attributes["title"],
            }]

            CSXML.add xml, 'recordStatus', attributes["record_status"]

            CSXML.add xml, 'comments', scrub_fields([attributes["comments"]])
          end
        end

      end

    end
  end
end
