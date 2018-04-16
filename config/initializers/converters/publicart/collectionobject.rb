module CollectionSpace
  module Converter
    module PublicArt
      include Default

      class PublicArtCollectionObject < CollectionObject

        def convert
          run do |xml|
            # objectNumber
            CSXML.add xml, 'objectNumber', attributes["objectnumber"]

            # numberOfObjects
            CSXML.add xml, 'numberOfObjects', attributes["number_of_objects"]

            #Title group list, need to check for language to avoid downcasing empty strings
            if attributes["title_translation"]
              CSXML.add_group_list xml, 'title', [{
              "title" => attributes["title"],
              "titleLanguage" => CSXML::Helpers.get_vocab_urn('languages', attributes["title_language"]),
              }], 'titleTranslation', [{
                "titleTranslation" => attributes["title_translation"],
                "titleTranslationLanguage" => CSXML::Helpers.get_vocab_urn('languages', attributes["title_translation_language"])
              }]
            elsif attributes["title_language"]
               CSXML.add_group_list xml, 'title', [{
              "title" => attributes["title"],
              "titleLanguage" => CSXML::Helpers.get_vocab_urn('languages', attributes["title_language"]),
              }]
            else
              CSXML.add_group_list xml, 'title', [{
              "title" => attributes["title"],
              }]
            end

            CSXML.add_list xml, 'objectName', [{
              "objectName" => attributes["objectname"],
            }], 'Group' if attributes["objectname"]


            CSXML.add_repeat xml, 'briefDescriptions', [{
              "briefDescription" => scrub_fields([attributes["briefdescription"]])
            }]

            # responsibleDepartments
            CSXML.add_repeat xml, 'responsibleDepartments', [{
              "responsibleDepartment" => attributes["responsible_department"]
            }] if attributes["responsible_department"]

            if attributes["collection"]
              CSXML.add xml, 'collection', attributes["collection"]
            end

            CSXML.add xml, 'recordStatus', attributes["record_status"]

            CSXML.add_repeat xml, 'comments', [{
              "comment_" => scrub_fields([attributes["comments"]])
            }]

            # measuredPartGroupList
            overall_data = {
              "measuredPart" => attributes["dimension_part"],
              "dimensionSummary" => attributes["dimension_summary"],
            }
            dimensions = []
            dims = split_mvf attributes, 'dimension'
            values = split_mvf attributes, 'value'
            unit = attributes["unit"]
            dims.each_with_index do |dim, index|
              dimensions << { "dimension" => dim, "value" => values[index], "measurementUnit" => unit }
            end
            CSXML.add_group_list xml, 'measuredPart', [ overall_data ], 'dimension', dimensions

            # contentPersons
            if attributes.fetch("content_person", nil)
              contentpersons = split_mvf attributes, 'content_person'
              CSXML::Helpers.add_persons xml, 'contentPerson', contentpersons, :add_repeat
            end

            # copyNumber
            CSXML.add xml, 'copyNumber', attributes["copy_number"]

            # editionNumber
            CSXML.add xml, 'editionNumber', attributes["edition_number"]

            # form
            CSXML.add_repeat xml, 'forms', [{
              "form" => attributes["form"]
            }]

            # textualInscriptionGroupList
            CSXML.add_group_list xml, 'textualInscription', [{
              inscriptionContentInscriber => CSXML::Helpers.get_authority_urn('personauthorities', 'person', attributes["inscriber"]),
              inscriptionContentMethod => attributes["method"],
            }] if attributes["inscriber"]

            # phase
            CSXML.add xml, 'phase', attributes["phase"]

            # sex
            CSXML.add xml, 'sex', attributes["sex"]

            # style
            CSXML.add_repeat xml, 'styles', [{
              "style" => attributes["style"]
            }]

            # technicalAttributeGroupList
            CSXML.add_group_list xml, 'technicalAttribute', [{
              "technicalAttribute" => attributes["tech_attribute"],
            }] if attributes["tech_attributes"]

            # objectComponentGroupList
            CSXML.add_group_list xml, "objectComponent", [{
              "objectComponentName" => attributes["object_component_name"]
            }]

            # objectProductionDateGroupList
            CSXML.add_group_list xml, "objectProductionDate", [{
              "dateDisplayDate" => attributes["objectproductiondate"]
            }]

            # objectProductionOrganizationGroupList
            CSXML.add_group_list xml, 'objectProductionOrganization', [{
              "objectProductionOrganization" => CSXML::Helpers.get_authority_urn('orgauthorities', 'organization', attributes["production_org"]),
              "objectProductionOrganizationRole" => attributes["organization_role"],
            }] if attributes["production_org"]

            # objectProductionPeopleGroupList
            CSXML.add_group_list xml, 'objectProductionPeople', [{
              "objectProductionPeople" => attributes["production_people"]
            }] if attributes["production_people"]

            # objectProductionPersonGroupList
            CSXML.add_group_list xml, 'objectProductionPerson', [{
              "objectProductionPerson" => CSXML::Helpers.get_authority_urn('personauthorities', 'person', attributes["objectproductionperson"]),
              "objectProductionPersonRole" => attributes["person_role"],
            }] if attributes["objectproductionperson"]

            # objectProductionPlaceGroupList
            CSXML.add_group_list xml, 'objectProductionPlace', [{
              "objectProductionPlace" => attributes["production_place"]
            }] if attributes["production_place"]

            CSXML.add_repeat xml, 'owners', [{
              "owner" => CSXML::Helpers.get_authority_urn('personauthorities', 'person', attributes["owner"]),
            }] if attributes["owner"]

            # materialGroupList
            mgs = []
            materials = split_mvf attributes, 'material'
            materials.each do |m|
              mgs << { "material" => CSXML::Helpers.get_authority_urn('conceptauthorities', 'material_ca', m) }
              #mgs << { "material" => m }
            end
            CSXML.add_group_list xml, 'material', mgs

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
        end

      end

    end
  end
end
