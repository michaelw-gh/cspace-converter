class DataObject
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  has_many :procedure_objects, autosave: true, dependent: :destroy

  field :batch,     type: String
  field :converter, type: String

  def to_cspace_xml(procedure)
    converter_type  = self.read_attribute(:converter)
    converter_class = "CollectionSpace::Converter::#{converter_type}".constantize
    check_valid_procedure!(procedure, converter_class)

    procedure_class = "#{converter_class}::#{converter_type}#{procedure}".constantize
    converter       = procedure_class.new(self.to_hash)
    converter.convert
  end

  def to_hash
    Hash[self.attributes]
  end

  private

  def check_valid_procedure!(procedure, converter)
    CollectionSpace::Converter::Default.validate_procedure!(procedure, converter)
  end

end
