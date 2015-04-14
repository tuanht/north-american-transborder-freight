# Renders an ItemContainer as a <ul> element and its containing items as <li> elements.
# It adds the 'selected' class to li element AND the link inside the li element that is currently active.
#
# If the sub navigation should be included (based on the level and expand_all options), it renders another <ul> containing the sub navigation inside the active <li> element.
#
# By default, the renderer sets the item's key as dom_id for the rendered <li> element unless the config option <tt>autogenerate_item_ids</tt> is set to false.
# The id can also be explicitely specified by setting the id in the html-options of the 'item' method in the config/navigation.rb file.
class TreeViewRenderer < SimpleNavigation::Renderer::Base
  def render(item_container)
    list_content = item_container.items.inject([]) do |list, item|
      li_options = item.html_options.reject {|k, v| k == :link}
      li_content = tag_for(item)
      if include_sub_navigation?(item)
        li_content << render_sub_navigation_for(item)
      end
      list << content_tag(:li, li_content, li_options)
    end.join
    if skip_if_empty? && item_container.empty?
      ''
    else
      content_tag((options[:ordered] ? :ol : :ul), list_content, {:id => item_container.dom_id, :class => item_container.dom_class})
    end
  end

  # determine and return link or static content depending on
  # item/renderer conditions.
  def tag_for(item)
    if suppress_link?(item)
      content_tag('span', item.name, link_options_for(item).except(:method))
    else
      # Icon tag
      icon = ''
      if item.html_options[:icon]
        icon_options = item.html_options.delete :icon
        icon = content_tag('i', '', :class => icon_options)
      end

      # Text tag
      text = content_tag('span', item.name)

      # Badge tag
      badge = ''
      if item.html_options[:badge]
        badge_options = {class: item.html_options[:badge][:class], text: item.html_options[:badge][:text]}.reject { |_, v| v.nil? }
        badge = content_tag('small', badge_options[:text], :class => badge_options[:class])
      end

      # Generate link
      link_to(icon.html_safe + text.html_safe + badge.html_safe, item.url, options_for(item))
    end
  end
end