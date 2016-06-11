class DataObject
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  has_many :procedure_objects, autosave: true, dependent: :destroy

  field :import_file,      type: String
  field :import_batch,     type: String
  field :import_converter, type: String
  field :import_profile,   type: String

  def to_auth_xml(authority, term_display_name)
    CollectionSpace::Converter::Default.validate_authority!(authority)
    authority_class = "CollectionSpace::Converter::Default::#{authority}".constantize
    converter       = authority_class.new({
      "shortIdentifier" => CollectionSpace::Identifiers.short_identifier(term_display_name),
      "termDisplayName" => term_display_name
    })
    converter.convert
  end

  def to_procedure_xml(procedure)
    converter_type  = self.read_attribute(:import_converter)
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
