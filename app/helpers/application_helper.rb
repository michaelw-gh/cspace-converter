module ApplicationHelper

  def converters
    CollectionSpace::Converter.constants
  end

  def profiles
    profiles = []
    CollectionSpace::Converter.constants.each do |c|
      converter = "CollectionSpace::Converter::#{c}".constantize
      converter.registered_profiles.keys.each do |profile|
        profiles << [profile, profile, class: c.to_s]
      end
    end
    profiles
  end

  def short_date(date)
    date.to_s(:short)
  end

end
