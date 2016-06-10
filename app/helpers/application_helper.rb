module ApplicationHelper

  def converters
    CollectionSpace::Converter.constants
  end

  def short_date(date)
    date.to_s(:short)
  end

end
