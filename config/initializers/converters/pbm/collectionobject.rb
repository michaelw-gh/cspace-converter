module CollectionSpace
  module Converter
    module PBM
      include Default

      class PBMCollectionObject < CollectionObject

        def convert
          # using bonsai extension therefore need to expose entire document
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

              collection = attributes['collection']
              CollectionSpace::XML.add xml, 'collection', collection.downcase if collection

              CollectionSpace::XML.add xml, 'distinguishingFeatures', attributes['distinguishingFeatures']

              comment = attributes['comment']
              CollectionSpace::XML.add_repeat xml, 'comments', [
                { "comment" => comment }
              ] if comment

              # production dates, origin is unusual because each field is mvf for a distinct date group
              date_display_foliage, date_display_trunk   = split_mvf attributes, 'originObjectProductionDateDisplayDate'
              date_assoc_foliage, date_assoc_trunk       = split_mvf attributes, 'originObjectProductionDateAssociation'
              date_earliest_foliage, date_earliest_trunk = split_mvf attributes, 'originObjectProductionDateEarliestSingleYear'
              date_latest_foliage, date_latest_trunk     = split_mvf attributes, 'originObjectProductionDateLatestYear'

              date_display_training  = attributes['trainingObjectProductionDateDisplayDate']
              date_assoc_training    = attributes['trainingObjectProductionDateAssociation']
              date_earliest_training = attributes['trainingProductionDateEarliestSingleYear']
              date_latest_training   = attributes['trainingObjectProductionDateLatestYear']

              objectProductionDates = [
                {
                  "dateDisplayDate"        => date_display_foliage,
                  "dateAssociation"        => date_assoc_foliage,
                  "dateEarliestSingleYear" => date_earliest_foliage,
                  "dateLatestYear"         => date_latest_foliage,
                },
              ]

              objectProductionDates << {
                "dateDisplayDate"        => date_display_trunk,
                "dateAssociation"        => date_assoc_trunk,
                "dateEarliestSingleYear" => date_earliest_trunk,
                "dateLatestYear"         => date_latest_trunk,
              } if date_display_trunk

              objectProductionDates << {
                "dateDisplayDate"        => date_display_training,
                "dateAssociation"        => date_assoc_training,
                "dateEarliestSingleYear" => date_earliest_training,
                "dateLatestYear"         => date_latest_training,
              } if date_display_training

              CollectionSpace::XML.add_group_list xml, 'objectProductionDate', objectProductionDates
            end

            xml.send(
              "ns2:collectionobjects_bonsai",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/local/bonsai",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil

              CollectionSpace::XML.add xml, 'commonName', attributes["commonName"]

              native = attributes["nativeSpecies"].blank? ? 'false' : 'true'
              CollectionSpace::XML.add xml, 'nativeSpecies', native

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