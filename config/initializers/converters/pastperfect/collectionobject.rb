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

              if attributes.fetch("recfrom", nil)
                owners = split_mvf attributes, 'recfrom'
                CSXML::Helpers.add_persons xml, 'owner', owners, :add_repeat
              end
            end

            xml.send(
              "ns2:collectionobjects_bm",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/local/bm",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
            end

            xml.send(
              "ns2:collectionobjects_fineart",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/domain/collectionobject",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
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