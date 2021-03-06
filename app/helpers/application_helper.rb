module ApplicationHelper

  # Return a title on a per-page basis.
  def title
    base_title = "Sample App"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  # Return logo image
  def logo
    logo = image_tag("logo.png", :alt => "Sample App", :class => "round", :height => "50");
  end

end
