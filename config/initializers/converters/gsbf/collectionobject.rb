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

              CSXML.add xml, 'objectNumber', attributes["objectNumber"]
              CSXML.add xml, 'physicalDescription', attributes['physicalDescription']

              CSXML.add_repeat xml, 'briefDescriptions',
                [ { "briefDescription" => attributes['briefDescription'] } ]
              # expanded description?

              CSXML.add_repeat xml, 'colors', [ { "color" => attributes["color"] } ]

              if attributes["comment"]
                # build renders "comment" as <!-- --> so append as string
                # TODO: check this, ain't working
                CSXML.add_string xml, "<comments><comment>#{attributes['comment']}</comment></comments>"
              else
                # smush these in here for now ...
                CSXML.add_repeat xml, 'comments', [ { "comment" => attributes["numberValue"] } ]
              end

              CSXML.add_group_list xml, 'measuredPart', [{ "dimensionSummary" => attributes["dimensionSummary"] }]

              if attributes.fetch("objectProductionOrganization1", nil)
                object_production_orgs = split_mvf attributes, 'objectProductionOrganization1'
                CSXML::Helpers.add_organizations xml, 'objectProductionOrganization', object_production_orgs
              end

              if attributes.fetch("objectProductionPerson1", nil)
                object_production_persons = split_mvf attributes, 'objectProductionPerson1'
                CSXML::Helpers.add_persons xml, 'objectProductionPerson', object_production_persons
              end

              if attributes.fetch("fieldCollectors", nil)
                field_collectors = split_mvf attributes, 'fieldCollectors'
                CSXML::Helpers.add_persons xml, 'fieldCollectors', field_collectors, :add_repeat
              end

              field_collection_date = {
                "dateDisplayDate"        => attributes["fieldCollectionDate"],
                "dateEarliestSingleYear" => attributes['fieldCollectionDateEarliest'],
                "dateLatestYear"         => attributes['fieldCollectionDateLatest'],
              }

              CSXML.add_group_list xml, 'fieldCollectionDate', [field_collection_date] if attributes["fieldCollectionDate"]

              CSXML::Helpers.add_place xml,
                'fieldCollectionPlace', attributes["fieldCollectionPlace"] if attributes["fieldCollectionPlace"]

              CSXML.add_group_list xml,
                'reference', [{ "referenceNote" => attributes["referenceNote"] }]

              display_date = attributes.fetch("objectProductionDateDisplayDate", attributes["objectProductionDateEarliest"])
              object_production_date = {
                "dateDisplayDate"        => display_date,
                "dateAssociation"        => attributes['objectProductionDateAssociation'],
                "dateEarliestSingleYear" => attributes['objectProductionDateEarliest'],
                "dateLatestYear"         => attributes['objectProductionDateLatestYear'],
              }

              CSXML.add_group_list xml, 'objectProductionDate', [object_production_date] if display_date
            end

            xml.send(
              "ns2:collectionobjects_bonsai",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/local/bonsai",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil

              CSXML.add xml, 'commonName', attributes["commonName"]
              CSXML.add xml, 'japaneseName', attributes["japaneseName"]
              CSXML.add xml, 'sponsor', attributes["sponsor"]

              native = attributes["nativeSpecies"].blank? ? 'false' : 'true'
              CSXML.add xml, 'nativeSpecies', native

              CSXML::Helpers.add_taxon xml, 'taxon', attributes["taxon"] if attributes["taxon"]

              ["treeType", "potStyle"].each do |bonsai_vocab|
                if attributes.fetch(bonsai_vocab, nil)
                  CSXML::Helpers.add_vocab xml, bonsai_vocab, attributes[bonsai_vocab]
                end
              end
            end

          end
        end

      end

    end
  end
end
