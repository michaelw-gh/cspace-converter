class CollectionSpaceObject
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :data_object, counter_cache: true
  validates  :identifier, uniqueness: true

  field :category,         type: String # Authority, Procedure
  field :type,             type: String
  field :identifier_field, type: String
  field :identifier,       type: String
  field :title,            type: String
  field :content,          type: String
  # fields from remote collectionspace
  field :csid,             type: String
  field :uri,              type: String

  attr_readonly :type

  scope :transferred, ->{ where(csid: true) } # TODO: check

  def self.has_authority?(identifier)
    identifier = self.where(category: 'Authority', identifier: identifier).first
    identifier ? true : false
  end

  def self.has_identifier?(identifier)
    identifier = self.where(identifier: identifier).first
    identifier ? true : false
  end

  def self.has_procedure?(identifier)
    identifier = self.where(category: 'Procedure', identifier: identifier).first
    identifier ? true : false
  end
end
