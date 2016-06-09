class DataObject
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  has_many :procedure_objects, autosave: true, dependent: :destroy

  def to_cspace_xml(procedure)
    check_valid_procedure!(procedure)
    converter_class = Rails.application.config.converter_class.constantize
    converter_type  = Rails.application.config.converter_type

    procedure_class = "#{converter_class}::#{converter_type}#{procedure}".constantize
    converter       = procedure_class.new(self.to_hash)
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
