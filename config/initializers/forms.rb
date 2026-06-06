# frozen_string_literal: true

# Remove the default error markup from form fields
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag.html_safe
end
