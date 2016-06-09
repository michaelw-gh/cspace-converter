module CollectionSpace
  module Converter
    module Default

      # set which procedures can be created from model
      def self.validate_procedure!(procedure)
        valid_procedures = Rails.application.config.converter_class.constantize.registered_procedures
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

        def run(service, procedure, common)
          builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
            xml.document(name: service) {
              if common
                xml.send(
                  "ns2:#{service}_common",
                  "xmlns:ns2" => "http://collectionspace.org/services/#{procedure}",
                  "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
                ) do
                  # applying namespace breaks import
                  xml.parent.namespace = nil
                  yield xml
                end
              else
                yield xml # entire document (for extensions)
              end
            }
          end
          builder.to_xml
        end

      end

      class CollectionObject < Record

        def run(wrapper: "common")
          common = wrapper == "common" ? true : false
          super 'collectionobjects', 'collectionobject', common
        end

      end

    end
  end
end