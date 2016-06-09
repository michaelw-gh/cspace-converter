class ProcedureObject
  include Mongoid::Document

  belongs_to :data_object

  field :type,       type: String
  field :identifier, type: String
  field :title,      type: String
  field :content,    type: String
  # fields from remote collectionspace
  field :csid,       type: String
  field :uri,        type: String

  attr_readonly :type
end
