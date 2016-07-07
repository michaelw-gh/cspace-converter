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

              if attributes.fetch("objectProductionPerson1", nil)
                object_production_persons = split_mvf attributes, 'objectProductionPerson1'
                CollectionSpace::XML::Helpers.add_persons xml, 'objectProductionPerson', object_production_persons
              end

              # fieldCollectors
              # fieldCollectionDate
              # fieldCollectionDateEarliest
              # fieldCollectionDateLatest
              # fieldCollectionPlace (check)

              if attributes.fetch("fieldCollectionPlace", nil)
                field_collection_places = split_mvf attributes, "fieldCollectionPlace"
                CollectionSpace::XML::Helpers.add_places xml, 'fieldCollectionPlace', field_collection_places
              end

              # sponsor
              # referenceNote

              CollectionSpace::XML.add xml, 'briefDescription', attributes['briefDescription']
              # expanded description?

              display_date = attributes.fetch("objectProductionDateDisplayDate", attributes["objectProductionDateEarliest"])
              object_production_date = {
                "dateDisplayDate"        => display_date,
                "dateAssociation"        => attributes['objectProductionDateAssociation'],
                "dateEarliestSingleYear" => attributes['objectProductionDateEarliest'],
                "dateLatestYear"         => attributes['objectProductionDateLatestYear'],
              }

              CollectionSpace::XML.add_group_list xml, 'objectProductionDate', [object_production_date] if display_date
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

              CollectionSpace::XML::Helpers.add_taxon xml, 'taxon', attributes["taxon"] if attributes["taxon"]

              ["treeType", "potStyle"].each do |bonsai_vocab|
                if attributes.fetch(bonsai_vocab, nil)
                  CollectionSpace::XML::Helpers.add_vocab xml, bonsai_vocab, attributes[bonsai_vocab]
                end
              end
            end

          end
        end

      end

    end
  end
end
