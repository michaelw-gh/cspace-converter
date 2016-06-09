module CollectionSpace
  module Converter
    module Default

      # set which procedures can be created from model
      def self.validate_procedure!(procedure)
        valid_procedures = Rails.application.config.registered_procedures
        unless valid_procedures.include?("all") or valid_procedures.include?(procedure)
          raise "Invalid procedure #{procedure}, not permitted by configuration."
        end
      end

      class Record
        attr_reader :attributes

        def initialize(attributes)
          @attributes = attributes
        end

        # implemented by sub-classes, returns converted record
        def convert
        end

      end

      class CollectionObject < Record

        def run
          builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
            xml.document(name: 'collectionobjects') {
              xml.send(
                'ns2:collectionobjects_common',
                'xmlns:ns2' => 'http://collectionspace.org/services/collectionobject',
                'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
              ) do
                # applying namespace breaks import
                xml.parent.namespace = nil
                yield xml # common
              end
            }
            # yield xml # document (for extensions)
          end
          builder.to_xml
        end

      end

    end
  end
end