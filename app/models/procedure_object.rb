class ProcedureObject
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  def to_cspace_xml(procedure)
    check_valid_procedure!(procedure)
    config_converter_type = Rails.application.config.converter_type

    converter_type = "CollectionSpace::Converter::#{config_converter_type}".constantize
    procedure_type = "#{converter_type}::#{config_converter_type}#{procedure}".constantize
    converter      = procedure_type.new(self.to_hash)
    converter.convert
  end

  def to_hash
    Hash[self.attributes]
  end

  private

  def check_valid_procedure!(procedure)
    CollectionSpace::Converter::Default.validate_procedure!(procedure)
  end

end
