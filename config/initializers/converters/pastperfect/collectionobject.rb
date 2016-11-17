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
              previous_number = attributes["otherno"] ? attributes["otherno"] : attributes["oldno"]
              CSXML.add_list xml, 'otherNumber', [{
                "numberType" => CSXML::Helpers.get_vocab_urn('bmnumbertype', 'Previous'),
                "numberValue" => previous_number,
              }] if previous_number

              # editionNumber - NM
              edition = attributes["edition"] ? attributes["edition"] : attributes["origcopy"]
              CSXML.add xml, 'editionNumber', edition if edition

              # copyNumber - NM
              copy_number = attributes["frameno"] ? attributes["frameno"] : attributes["negno"]
              CSXML.add xml, "copyNumber" if copy_number

              # numberOfObjects (1?) n/a

              CSXML.add xml, 'recordStatus', 'new'

              # responsibleDepartments n/a

              collection = attributes["collection"]
              CSXML.add xml, 'collection', CSXML::Helpers.get_vocab_urn('bmcollection', collection) if collection

              CSXML.add_repeat xml, 'briefDescriptions', [{ "briefDescription" => scrub_fields([attributes["descrip_"]]) }]
              CSXML.add xml, 'distinguishingFeatures', scrub_fields([attributes["notes_"]])
              CSXML.add xml, 'physicalDescription', attributes["physchar"]
              CSXML.add xml, 'comments', scrub_fields([attributes["pubnotes_"]])

              # objectNameList
              objname = attributes["objname"]
              gparent = attributes["gparent"]
              # cleanup will deviate from generated authority, so do it later
              # gparent = gparent.gsub(/^\d+: /, '') if gparent
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
              CSXML.add xml, 'objectHistoryNote', scrub_fields([attributes["custodial"], attributes["provenanc_"]])

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