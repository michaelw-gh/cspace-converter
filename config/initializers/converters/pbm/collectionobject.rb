module CollectionSpace
  module Converter
    module PBM
      include Default

      class PBMCollectionObject < CollectionObject

        def convert
          run(wrapper: "document") do |xml|
            xml.send(
              "ns2:collectionobjects_common",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil

              CollectionSpace::XML.add xml, 'objectNumber', attributes["objectNumber"]
              CollectionSpace::XML.add_group_list xml, 'title', [{
                "title" => attributes["title"],
              }]

              if attributes["objectProductionPerson1"]
                objectProductionPersons = split_mvf attributes, 'objectProductionPerson1'
                objectProductionPersons = objectProductionPersons.map do |person|
                  {
                    "objectProductionPerson" => CollectionSpace::URN.generate(
                      Rails.application.config.domain,
                      "personauthorities",
                      "person",
                      CollectionSpace::Identifiers.short_identifier(person),
                      person
                    ),
                  }
                end
                CollectionSpace::XML.add_group_list xml, 'objectProductionPerson', objectProductionPersons
              end

              CollectionSpace::XML.add_group_list xml, 'objectProductionPlace', [{
                "objectProductionPlace" => CollectionSpace::URN.generate(
                  Rails.application.config.domain,
                  "placeauthorities",
                  "place",
                  CollectionSpace::Identifiers.short_identifier(attributes["objectProductionPlace1"]),
                  attributes["objectProductionPlace1"]
                ),
              }] if attributes["objectProductionPlace1"]
            end

            xml.send(
              "ns2:collectionobjects_bonsai",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/local/bonsai",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil

              CollectionSpace::XML.add xml, 'commonName', attributes["commonName"]
              CollectionSpace::XML.add xml, 'taxon', CollectionSpace::URN.generate(
                Rails.application.config.domain,
                "taxonomyauthority",
                "taxon",
                CollectionSpace::Identifiers.short_identifier(attributes["taxon"]),
                attributes["taxon"]
              ) if attributes["taxon"]
            end

          end
        end

      end

    end
  end
end