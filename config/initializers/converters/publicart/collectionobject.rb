module CollectionSpace
  module Converter
    module PublicArt
      include Default

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

              # Public Art - Work type
              CSXML.add_list xml, 'objectName', [{
                   "objectName" => attributes["objectname"],
                   "objectNameNote" => attributes["objectNameNote"],
              }], 'Group' if attributes["objectname"]

              #Title group list, need to check for language to avoid downcasing empty strings
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
                "titleType" => attributes["titleType"],
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

              CSXML.add_repeat xml, 'owners', [{
                "owner" => CSXML::Helpers.get_authority_urn('personauthorities', 'person', attributes["owner"]),
              }] if attributes["owner"]

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

              # Collection
              CSXML.add_repeat xml, 'publicartCollections', [{
                  "publicartCollection" => CSXML::Helpers.get_authority_urn('orgauthorities', 'organization', attributes["collection"]),
              }] if attributes["collection"]

              # Artwork creator
              CSXML.add_group_list xml, 'publicartProductionPerson', [{
                  "publicartProductionPersonType" => attributes["objectproductionpersontype"],
                  "publicartProductionPersonRole" => CSXML::Helpers.get_vocab_urn('prodpersonrole', attributes["objectproductionpersonrole"]),
                  "publicartProductionPerson" => CSXML::Helpers.get_authority_urn('personauthorities', 'person', attributes["objectproductionperson"]),
              }] if attributes["objectproductionperson"]
            end
          end
        end
      end
    end
  end
end
