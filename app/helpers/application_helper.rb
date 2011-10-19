module ApplicationHelper
  def page_title
    "#{@page_title || controller.controller_name.humanize.titleize} - #{App.programmatic_name}"
  end
  
  def body_id
    @body_id ||= "#{controller.controller_name.underscore}"
  end
  
  def navigation_tab(title, options = {})
    %Q[<li>#{link_to_with_active_state(title, options.except(:accesskey), :accesskey => options[:accesskey])}</li>]
  end
  
  # Note - When giving a block to this helper, use <%. Otherwise, use <%= 
  def flash_display(flash_type, &block)
    message = flash_message_for(flash_type)
    return '' if message.nil?
    marked_up_message = build_flash_display(message)
    (block_given?) ? wrap_flash(marked_up_message, flash_type, &block) : %Q[<div id="flash_#{flash_type}">#{marked_up_message}</div>]
  end

  def build_flash_display(message)
    content_tag(:p) do
      message
    end
  end
  
  def wrap_flash(content, flash_type, &block)
    content_tag(:div, :class => 'flash', :id => "flash_#{flash_type}") do
      yield(content)
    end
  end
  
  def flash_message_for(type)
    flash[type.to_sym]
  end
end
