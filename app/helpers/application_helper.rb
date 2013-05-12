module ApplicationHelper
  def title(title_suffix)
    title_base='Nimbus'
    return title_base if title_suffix.empty?
    "#{title_base} | #{title_suffix}"
  end
end
