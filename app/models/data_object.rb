class DataObject
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  has_many :collection_space_objects, autosave: true, dependent: :destroy

  field :import_file,      type: String
  field :import_batch,     type: String
  field :import_converter, type: String
  field :import_profile,   type: String

  # "Person" => ["recby", "recfrom"]
  def add_authorities(authority, fields)
    fields.each do |field|
      term_display_name = self.read_attribute(field)
      next unless term_display_name

      # attempt to split field in case it is multi-valued
      term_display_name.split(Rails.application.config.csv_mvf_delimiter).map(&:strip).each do |name|
        identifier = CollectionSpace::Identifiers.short_identifier(name)
        # pre-filter authorities as we only want to create the first occurrence
        # and not fail CollectionSpaceObject validation for unique_identifier
        next if CollectionSpaceObject.has_authority?(identifier)

        data = {}
        # check for existence or update
        data[:category]         = "Authority"
        data[:type]             = authority
        data[:identifier_field] = 'shortIdentifier'
        data[:identifier]       = identifier
        data[:title]            = name
        data[:content]          = self.to_auth_xml(authority, name)
        self.collection_space_objects.build data
      end
    end
  end

  # "Acquisition" => { "identifier_field" => "acqid", "identifier" => "acqid", "title" => "acqid" }
  def add_procedure(procedure, attributes)
    data = {}
    # check for existence or update
    data[:category]         = "Procedure"
    data[:type]             = procedure
    data[:identifier_field] = attributes["identifier_field"]
    data[:identifier]       = self.read_attribute( attributes["identifier"] )
    data[:title]            = self.read_attribute( attributes["title"] )
    data[:content]          = self.to_procedure_xml(procedure)
    self.collection_space_objects.build data
  end

  # [ { "procedure1_type" => "Acquisition",
  #   "procedure1_field" => "acquisitionReferenceNumber",
  #   "procedure2_type" => "CollectionObject",
  #   "procedure2_field" => "objectNumber" } ]
  def add_relationships(relationships, reciprocal = true)
    relationships.each do |relationship|
      r  = relationship
      begin
        add_relationship r["procedure1_type"], r["procedure1_field"],
          r["procedure2_type"], r["procedure2_field"]

        add_relationship r["procedure2_type"], r["procedure2_field"],
          r["procedure1_type"], r["procedure1_field"] if reciprocal

        self.save!
      rescue Exception => ex
        # TODO: log.warn
        # puts ex.message
      end
    end
  end

  def set_attributes(attributes = {})
    attributes.each do |attribute, value|
      self.write_attribute attribute, value
    end
  end

  def to_auth_xml(authority, term_display_name)
    CollectionSpace::Converter::Default.validate_authority!(authority)
    authority_class = "CollectionSpace::Converter::Default::#{authority}".constantize
    converter       = authority_class.new({
      "shortIdentifier" => CollectionSpace::Identifiers.short_identifier(term_display_name),
      "termDisplayName" => term_display_name,
      "termType"        => "#{authority.downcase}Term",
    })
    # scary hack for namespaces
    hack_namespaces converter.convert
  end

  def to_procedure_xml(procedure)
    converter_type  = self.read_attribute(:import_converter)
    converter_class = "CollectionSpace::Converter::#{converter_type}".constantize
    check_valid_procedure!(procedure, converter_class)

    procedure_class = "#{converter_class}::#{converter_type}#{procedure}".constantize
    converter       = procedure_class.new(self.to_hash)
    # scary hack for namespaces
    hack_namespaces converter.convert
  end

  def to_relationship_xml(attributes)
    relationship_class = "CollectionSpace::Converter::Default::Relationship".constantize
    converter          = relationship_class.new(attributes)
    # scary hack for namespaces
    hack_namespaces converter.convert
  end

  def to_hash
    Hash[self.attributes]
  end

  private

  def add_relationship(from_procedure, from_field, to_procedure, to_field)
    from_value = self.read_attribute( from_field )
    to_value   = self.read_attribute( to_field )
    raise "No data for field pair [#{from_field}:#{to_field}] for #{self.id}" unless from_value and to_value

    # TODO: update this (lookup dock_type)!
    from_doc_type = "#{from_procedure.downcase}s"
    from          = CollectionSpaceObject.where(type: from_procedure, identifier: from_value).first
    to_doc_type   = "#{to_procedure.downcase}s"
    to            = CollectionSpaceObject.where(type: to_procedure, identifier: to_value).first
    raise "Object pair not found [#{from_value}:#{to_value}] for #{self.id}" unless from and to

    from_csid = from.read_attribute "csid"
    to_csid   = to.read_attribute   "csid"
    unless from_csid and to_csid
      raise "CSID values not found for pair [#{from.identifier}:#{to.identifier}] for #{self.id}"
    end

    attributes = {
      "from_csid" => from_csid,
      "from_doc_type" => from_doc_type,
      "to_csid" => to_csid,
      "to_doc_type" => to_doc_type,
    }

    data = {}
    data[:category]         = "Relationship"
    data[:type]             = "Relationship"
    # this will allow remote actions to happen (but not prevent duplicates?)
    data[:identifier_field] = 'csid'
    data[:identifier]       = "#{from_csid}_#{to_csid}"
    data[:title]            = "#{from_value}_#{to_value}"
    data[:content]          = self.to_relationship_xml(attributes)
    self.collection_space_objects.build data
  end

  def check_valid_procedure!(procedure, converter)
    CollectionSpace::Converter::Default.validate_procedure!(procedure, converter)
  end

  def hack_namespaces(xml)
    xml.to_s.gsub(/(<\/?)(\w+_)/, '\1ns2:\2')
  end

end
