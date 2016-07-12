module CollectionSpace
  module Converter
    module GSBF
      include Default

      class GSBFObjectExit < ObjectExit

        def convert
          run do |xml|
            CSXML.add xml, 'exitNumber', attributes["objectExitNumber"]
            CSXML.add xml, 'exitNote',   attributes["exitNote"]

            CSXML.add_group xml, 'exitDate', {
              "dateDisplayDate" => attributes["exitDateGroupDisplayDate"],
            }

            exit_reason = attributes["exitReason"].nil? ?
              nil : attributes["exitReason"].downcase
            CSXML.add xml, 'exitReason', exit_reason
          end
        end

      end

    end
  end
end
