module CollectionSpace
  module Converter
    module PastPerfect
      include Default

      class PastPerfectCollectionObject < CollectionObject

        def convert
          run(wrapper: "document") do |xml|
            xml.send(
              "ns2:collectionobjects_common",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              CSXML.add xml, 'objectNumber', attributes["objectid"]

              CSXML.add_group_list xml, 'title', [{
                "title" => attributes["title"],
              }]

              CSXML.add xml, 'recordStatus', 'new'

              collection = attributes["collection"]
              CSXML.add xml, 'collection', CSXML::Helpers.get_vocab_urn('bmcollection', collection) if collection

              CSXML.add_repeat xml, 'briefDescriptions', [{ "briefDescription" => scrub_fields([attributes["descrip_"]]) }]
              CSXML.add xml, 'distinguishingFeatures', scrub_fields([attributes["notes_"]])

              if attributes.fetch("recfrom", nil)
                owners = split_mvf attributes, 'recfrom'
                CSXML::Helpers.add_persons xml, 'owner', owners, :add_repeat
              end

              CSXML.add xml, 'assocEventName', attributes["event"]
            end

            xml.send(
              "ns2:collectionobjects_bm",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/local/bm",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              CSXML.add xml, 'conditionStatus', CSXML::Helpers.get_vocab_urn('conditionstatus', 'Exhibitable/Needs no work')
              CSXML.add xml, 'approvedForWeb', "false"
            end

            xml.send(
              "ns2:collectionobjects_fineart",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/domain/collectionobject",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              CSXML.add xml, 'materialTechniqueDescription', attributes["medium"]
              CSXML.add xml, 'catalogLevel', CSXML::Helpers.get_vocab_urn('cataloglevel', ' item ', true)
            end

            xml.send(
              "ns2:collectionobjects_variablemedia",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/domain/collectionobject",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
            end
          end
        end

      end

    end
  end
end