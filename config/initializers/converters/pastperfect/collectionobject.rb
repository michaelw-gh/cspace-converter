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

              # otherNumberList - NM
              # editionNumber - NM
              # copyNumber - NM
              # numberOfObjects (1?)

              CSXML.add xml, 'recordStatus', 'new'

              # responsibleDepartments

              collection = attributes["collection"]
              CSXML.add xml, 'collection', CSXML::Helpers.get_vocab_urn('bmcollection', collection) if collection

              CSXML.add_repeat xml, 'briefDescriptions', [{ "briefDescription" => scrub_fields([attributes["descrip_"]]) }]
              CSXML.add xml, 'distinguishingFeatures', scrub_fields([attributes["notes_"]])
              # physicalDescription
              # comments

              # objectNameList
              objname = attributes["objname"]
              gparent = attributes["gparent"]
              gparent = gparent.gsub(/^\d+: /, '') if gparent
              parent  = attributes["parent"]

              objname_group = {}
              objname_group = objname_group.merge({
                "objectName" => CSXML::Helpers.get_authority_urn('conceptauthorities', 'objectname', objname),
              }) if objname

              objname_group = objname_group.merge({
                "objectNameSystem" => CSXML::Helpers.get_authority_urn('conceptauthorities', 'category', gparent),
              }) if gparent

              objname_group = objname_group.merge({
                "objectNameType" => CSXML::Helpers.get_authority_urn('conceptauthorities', 'subcategory', parent),
              }) if parent

              CSXML.add_list xml, 'objectName', [ objname_group ], 'Group' unless objname_group.empty?
              # objectHistoryNote

              if attributes.fetch("recfrom", nil)
                owners = split_mvf attributes, 'recfrom'
                CSXML::Helpers.add_persons xml, 'owner', owners, :add_repeat
              end

              CSXML.add xml, 'assocEventName', attributes["event"]
              # assocEventNote - distinct field from name?

              # assocDateGroupList
              # assocPlaceGroupList
              # assocPersonGroupList (x 2)
              # assocOrganizationGroupList

              # objectProductionDateGroupList
              # objectProductionPlaceGroupList
              # objectProductionPersonGroupList
              # objectProductionOrganizationGroupList

              # ownershipExchangeMethod
              # ownershipExchangePriceValue
              # ownershipPlace
              # ownershipCategory

              # materialGroupList
              # textualInscriptionGroupList
              # measuredPartGroupList
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
              # creatorDescription
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