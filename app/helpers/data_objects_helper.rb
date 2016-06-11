module DataObjectsHelper

  def object_label(object)
    "#{object.id} #{object.import_batch} #{object.import_converter} #{object.import_profile}"
  end

end
