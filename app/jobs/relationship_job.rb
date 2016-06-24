class RelationshipJob < ActiveJob::Base
  queue_as :default

  def perform(import_batch, import_converter, import_profile)
    converter_class  = "CollectionSpace::Converter::#{import_converter}".constantize
    profiles         = converter_class.registered_profiles
    profile          = profiles[import_profile]
    raise "Invalid profile #{import_profile} for #{profiles}" unless profile

    objects = DataObject.where(import_profile: import_profile, import_batch: import_batch)

    # "Relationships" => [ {...} ]
    relationships = profile["Relationships"]
    objects.each do |object|
      # clear out any existing relationships
      object.collection_space_objects.where(category: 'Relationship').destroy_all
      object.add_relationships relationships if relationships and relationships.any?
    end
  end
end
