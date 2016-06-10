module DataObjectsHelper

  def object_label(object)
    "#{object.id} #{object.batch} #{object.converter} #{object.profile}"
  end

end
