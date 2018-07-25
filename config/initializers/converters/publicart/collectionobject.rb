module CollectionSpace
  module Converter
    module PublicArt
      include Default

      COMMON_ERA_URN = "urn:cspace:publicart.collectionspace.org:vocabularies:name(dateera):item:name(ce)'CE'"

      class PublicArtCollectionObject < CollectionObject

        def convert
          run(wrapper: "document") do |xml|

            xml.send(
                "ns2:collectionobjects_common",
                "xmlns:ns2" => "http://collectionspace.org/services/collectionobject",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              # objectNumber
              CSXML.add xml, 'objectNumber', attributes["objectnumber"]

              # numberOfObjects
              CSXML.add xml, 'numberOfObjects', attributes["numberOfObjects"]

              CSXML.add_repeat xml, 'briefDescriptions', [{
                  "briefDescription" => scrub_fields([attributes["briefdescription"]])
              }]

              CSXML.add xml, 'recordStatus', attributes["recordStatus"]

              # objectNameList
              namegroups = []
              objectnames = split_mvf attributes, 'objectname'
              objectnamenotes = split_mvf attributes, 'objectnamenotes'
              objectnames.each_with_index do |name, index|
                namegroups << { "objectName" => name, "objectNameNote" => objectnamenotes[index] }
              end
              CSXML.add_nogroup_list xml, 'objectName', namegroups

              # Title group list, need to check for language to avoid downcasing empty strings
              if attributes["title_translation"]
                CSXML.add_group_list xml, 'title', [{
                "title" => attributes["title"],
                "titleType" => attributes["titleType"],
                "titleLanguage" => CSXML::Helpers.get_vocab_urn('languages', attributes["titleLanguage"]),
                }], 'titleTranslation', [{
                  "titleTranslation" => attributes["titleTranslation"],
                  "titleTranslationLanguage" => CSXML::Helpers.get_vocab_urn('languages', attributes["titleTranslationLanguage"])
                }]
              elsif attributes["titleLanguage"]
                 CSXML.add_group_list xml, 'title', [{
                "title" => attributes["title"],
                "titleType" => attributes["titleType"],
                "titleLanguage" => CSXML::Helpers.get_vocab_urn('languages', attributes["titleLanguage"]),
                }]
              else
                CSXML.add_group_list xml, 'title', [{
                "title" => attributes["title"],
                "titleType" => attributes["titletype"],
                }]
              end

              # materialGroupList
              mgs = []
              materials = split_mvf attributes, 'material'
              materials.each do |m|
                mgs << { "material" => CSXML::Helpers.get_authority_urn('conceptauthorities', 'material_ca', m) }
                #mgs << { "material" => m }
              end
              CSXML.add_group_list xml, 'material', mgs

              # measuredPartGroupList
              overall_data = {
                  "measuredPart" => attributes["dimensionpart"],
                  "dimensionSummary" => attributes["dimensionsummary"],
              }
              dimensions = []
              dims = split_mvf attributes, 'dimension'
              values = split_mvf attributes, 'dimensionvalue'
              unit = attributes["dimensionmeasurementunit"]
              dims.each_with_index do |dim, index|
                dimensions << { "dimension" => dim, "value" => values[index], "measurementUnit" => unit }
              end
              CSXML.add_group_list xml, 'measuredPart', [ overall_data ], 'dimension', dimensions

              # textualInscriptionGroupList
              CSXML.add_group_list xml, 'textualInscription', [{
                inscriptionContentInscriber => CSXML::Helpers.get_authority_urn('personauthorities', 'person', attributes["inscriber"]),
                inscriptionContentMethod => attributes["method"],
              }] if attributes["inscriber"]

              # objectProductionOrganizationGroupList
              CSXML.add_group_list xml, 'objectProductionOrganization', [{
                "objectProductionOrganization" => CSXML::Helpers.get_authority_urn('orgauthorities', 'organization', attributes["production_org"]),
                "objectProductionOrganizationRole" => attributes["organization_role"],
              }] if attributes["production_org"]

              # objectProductionPeopleGroupList
              CSXML.add_group_list xml, 'objectProductionPeople', [{
                "objectProductionPeople" => attributes["production_people"]
              }] if attributes["production_people"]

              # objectProductionPlaceGroupList
              CSXML.add_group_list xml, 'objectProductionPlace', [{
                "objectProductionPlace" => attributes["production_place"]
              }] if attributes["production_place"]

              # owners
              owner_urns = []
              owners = split_mvf attributes, 'owner'
              owners.each do |owner|
                owner_urns << { "owner" => CSXML::Helpers.get_authority_urn('personauthorities', 'person', owner) }
              end
              CSXML.add_repeat(xml, 'owners', owner_urns) if attributes["owner"]

              # techniqueGroupList
              tgs = []
              techniques = split_mvf attributes, 'technique'
              techniques.each do |t|
                tgs << { "technique" => t }
              end
              CSXML.add_group_list xml, 'technique', tgs

              # objectStatusList
              CSXML.add_list xml, 'objectStatus', [{
                "objectStatus" => attributes["object_status"]
              }] if attributes["object_status"]

              # fieldColEventNames
              CSXML.add_repeat xml, 'fieldColEventNames', [{
                "fieldColEventName" => attributes["field_collection_event_name"]
              }]
            end

            #
            # Public Art extension fields
            #
            xml.send(
                "ns2:collectionobjects_publicart",
                "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/domain/collectionobject",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil

              # Example XML payload
              #
              # Column 'objectProductionDate' should map to the <dateDisplayDate> element
              # Column 'objectProductionDateType' should map to the <publicartProductionDateType> element
              #
              # <publicartProductionDateGroupList>
              #     <publicartProductionDateGroup>
              #         <publicartProductionDate>
              #             <dateDisplayDate>7/4/1776</dateDisplayDate>
              #         </publicartProductionDate>
              #         <publicartProductionDateType>
              #             urn:cspace:publicart.collectionspace.org:vocabularies:name(proddatetype):item:name(commission)'commission'
              #         </publicartProductionDateType>
              #     </publicartProductionDateGroup>
              # </publicartProductionDateGroupList>
              #
              proddategroups = []
              proddates = split_mvf attributes, 'objectproductiondate'
              proddatetypes = split_mvf attributes, 'objectproductiondatetype'
              proddates.each_with_index do |date, index|
                proddategroups << { "publicartProductionDate" => date, "publicartProductionDateType" => proddatetypes[index] }
              end

              xml.send("publicartProductionDateGroupList".to_sym) {
                proddategroups.each do |element|
                  xml.send("publicartProductionDateGroup".to_sym) {
                    xml.send("publicartProductionDate".to_sym) {
                      xml.send("dateEarliestSingleYear".to_sym, element["publicartProductionDate"])
                      xml.send("dateDisplayDate".to_sym, element["publicartProductionDate"])
                      xml.send("dateEarliestSingleEra".to_sym, COMMON_ERA_URN)
                    }
                    xml.send("publicartProductionDateType".to_sym, element["publicartProductionDateType"])
                  }
                end
              }

              # Collection
              CSXML.add_repeat xml, 'publicartCollections', [{
                  "publicartCollection" => CSXML::Helpers.get_authority_urn('orgauthorities', 'organization-paa', attributes["collection"]),
              }] if attributes["collection"]

              # publicartProductionPersonGroupList
              prodpersongroups = []
              prodpersons = split_mvf attributes, 'objectproductionperson'
              role_urns = []
              roles = split_mvf attributes, 'objectproductionpersonrole'
              roles.each do |role, index|
                role_urns << CSXML::Helpers.get_vocab_urn('prodpersonrole', role)
              end
              types = split_mvf attributes, 'objectproductionpersontype'
              prodpersons.each_with_index do |name, index|
                prodpersongroups << { "publicartProductionPerson" => name, "publicartProductionPersonRole" => role_urns[index], "publicartProductionPersonType" => types[index] }
              end
              CSXML.add_group_list xml, 'publicartProductionPerson', prodpersongroups
            end
          end
        end
      end
    end
  end
end
