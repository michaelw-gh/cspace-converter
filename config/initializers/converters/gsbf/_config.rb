module CollectionSpace
  module Converter
    module GSBF

      def self.registered_procedures
        [
          "Acquisition",
          "CollectionObject",
          "ConditionCheck",
          "Conservation",
          "LoanOut",
          "ObjectExit",
          "ValuationControl",
        ]
      end

      def self.registered_profiles
        {
          "acquisition" => {
            "Procedures" => {
              "Acquisition" => {
                "identifier_field" => "acquisitionReferenceNumber",
                "identifier" => "acquisitionReferenceNumber",
                "title" => "acquisitionReferenceNumber",
              },
            },
            "Authorities" => {
              "Person" => ["acquisitionSource1", "acquisitionSource2"],
            },
            "Relationships" => [
              {
                "procedure1_type"  => "Acquisition",
                "procedure1_field" => "acquisitionReferenceNumber",
                "procedure2_type"  => "CollectionObject",
                "procedure2_field" => "objectNumber",
              },
            ],
          },
          "cataloging" => {
            "Procedures" => {
              "CollectionObject" => {
                "identifier_field" => "objectNumber",
                "identifier" => "objectNumber",
                "title" => "title",
              }
            },
            "Authorities" => {
              "Organization" => ["objectProductionOrganization1", "sponsor"],
              "Person"       => ["fieldCollectors", "objectProductionPerson1"],
              "Place"        => ["fieldCollectionPlace", "objectProductionPlace1"],
              "Taxon"        => ["taxon"],
            },
            "Relationships" => [
              {
                "procedure1_type"  => "CollectionObject",
                "procedure1_field" => "relatedObjectNumber",
                "procedure2_type"  => "CollectionObject",
                "procedure2_field" => "objectNumber",
              },
            ],
          },
          "conditioncheck" => {
            "Procedures" => {
              "ConditionCheck" => {
                "identifier_field" => "objectNumber",
                "identifier" => "objectNumber",
                "title" => "objectNumber",
              },
            },
            "Authorities" => {
              "Person" => ["assessor", "conditionChecker"],
            },
            "Relationships" => [
              {
                "procedure1_type"  => "ConditionCheck",
                "procedure1_field" => "conditionCheckRefNumber",
                "procedure2_type"  => "CollectionObject",
                "procedure2_field" => "objectNumber",
              },
            ],
          },
          "conservation" => {
            "Procedures" => {
              "Conservation" => {
                "identifier_field" => "conservationNumber",
                "identifier" => "conservationNumber",
                "title" => "conservationNumber",
              },
            },
            "Authorities" => {
              "Person" => ["appliedBy", "conservators", "identifiedBy", "treatedBy"],
            },
            "Relationships" => [
              {
                "procedure1_type"  => "Conservation",
                "procedure1_field" => "conservationNumber",
                "procedure2_type"  => "CollectionObject",
                "procedure2_field" => "objectNumber",
              },
            ],
          },
          "loanout" => {
            "Procedures" => {
              "LoanOut" => {
                "identifier_field" => "loanOutNumber",
                "identifier" => "loanOutNumber",
                "title" => "loanOutNumber",
              },
            },
            "Authorities" => {
              "Person" => ["lendersAuthorizer"],
            },
            "Relationships" => [
              {
                "procedure1_type"  => "LoanOut",
                "procedure1_field" => "loanOutNumber",
                "procedure2_type"  => "CollectionObject",
                "procedure2_field" => "objectNumber",
              },
            ],
          },
          "objectexit" => {
            "Procedures" => {
              "ObjectExit" => {
                "identifier_field" => "objectExitNumber",
                "identifier" => "objectExitNumber",
                "title" => "objectExitNumber",
              },
            },
            "Authorities" => {},
            "Relationships" => [
              {
                "procedure1_type"  => "objectExit",
                "procedure1_field" => "objectExitNumber",
                "procedure2_type"  => "CollectionObject",
                "procedure2_field" => "objectNumber",
              },
            ],
          },
          "valuationcontrol" => {
            "Procedures" => {
              "ValuationControl" => {
                "identifier_field" => "valuationcontrolRefNumber",
                "identifier" => "valuationcontrolRefNumber",
                "title" => "valuationcontrolRefNumber",
              }
            },
            "Authorities" => {},
            "Relationships" => [
              {
                "procedure1_type"  => "ValuationControl",
                "procedure1_field" => "valuationcontrolRefNumber",
                "procedure2_type"  => "CollectionObject",
                "procedure2_field" => "objectNumber",
              },
            ],
          }
        }
      end

    end
  end
end
