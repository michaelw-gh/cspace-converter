module DataObjectsHelper

  def object_label(object)
    "#{object.batch} #{object.converter} #{object.profile} #{object.id}"
  end

end
