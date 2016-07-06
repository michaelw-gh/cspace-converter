module CollectionSpace
  module Converter
    module GSBF
      include Default

      class GSBFCollectionObject < CollectionObject

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
              # numberValue

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

              # fieldCollectors
              # fieldCollectionDate
              # fieldCollectionDateEarliest
              # fieldCollectionDateLatest
              # fieldCollectionPlace (check)

              CollectionSpace::XML.add_group_list xml, 'fieldCollectionPlace', [{
                "fieldCollectionPlace" => CollectionSpace::URN.generate(
                  Rails.application.config.domain,
                  "placeauthorities",
                  "place",
                  CollectionSpace::Identifiers.short_identifier(attributes["fieldCollectionPlace"]),
                  attributes["fieldCollectionPlace"]
                ),
              }] if attributes["fieldCollectionPlace"]

              # sponsor
              # referenceNote

              CollectionSpace::XML.add xml, 'briefDescription', attributes['briefDescription']
              # expanded description?

              date_display  = attributes['objectProductionDateDisplayDate']
              date_assoc    = attributes['objectProductionDateAssociation']
              date_earliest = attributes['objectProductionDateEarliest']
              date_latest   = attributes['objectProductionDateLatestYear']

              objectProductionDates << {
                "dateDisplayDate"        => date_display,
                "dateAssociation"        => date_assoc,
                "dateEarliestSingleYear" => date_earliest,
                "dateLatestYear"         => date_latest,
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
              CollectionSpace::XML.add xml, 'japaneseName', attributes["japaneseName"]

              native = attributes["nativeSpecies"].blank? ? 'false' : 'true'
              CollectionSpace::XML.add xml, 'nativeSpecies', native

              CollectionSpace::XML.add xml, 'taxon', CollectionSpace::URN.generate(
                Rails.application.config.domain,
                "taxonomyauthority",
                "taxon",
                CollectionSpace::Identifiers.short_identifier(attributes["taxon"]),
                attributes["taxon"]
              ) if attributes["taxon"]

              # treeType & potStyle
              ["treeType", "potStyle"].each do |bonsai_vocab|
                CollectionSpace::XML.add xml, bonsai_vocab, CollectionSpace::URN.generate(
                  Rails.application.config.domain,
                  "vocabularies",
                  bonsai_vocab.downcase,
                  CollectionSpace::Identifiers.for_option(attributes[bonsai_vocab]),
                  attributes[bonsai_vocab]
                ) if attributes[bonsai_vocab]
              end
            end

          end
        end

      end

    end
  end
end
