module DataObjectsHelper

  def object_label(object)
    "#{object.id} #{object.import_batch} #{object.converter_type} #{object.converter_profile}"
  end

end
