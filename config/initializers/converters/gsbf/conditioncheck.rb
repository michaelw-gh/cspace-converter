module CollectionSpace
  module Converter
    module GSBF
      include Default

      class GSBFConditionCheck < ConditionCheck

        def convert
          run do |xml|
            CSXML.add xml, 'conditionCheckRefNumber', attributes["conditionCheckRefNumber"]
            CSXML.add xml, 'specialRequirements', attributes["specialRequirements"]

            if attributes.fetch "conditionChecker", nil
              CSXML::Helpers.add_person xml, 'conditionChecker', attributes["conditionChecker"]
            end

            note = attributes["conditionCheckNote"]
            if attributes.fetch "conditionCheckAssessmentDate", nil
              # TODO: review, but these dates are messy and cannot be easily parsed into a structured date
              date = attributes['conditionCheckAssessmentDate'].to_s
              if note
                note = "#{note}. #{date}".squeeze('.')
              else
                note = date
              end
            end
            CSXML.add xml, 'conditionCheckNote', note
          end
        end

      end

    end
  end
end
