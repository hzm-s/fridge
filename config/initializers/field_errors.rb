# typed: ignore
FRIDGE_FIELD_ERROR_IGNORE_CLASSES = [
  ActionView::Helpers::Tags::Label,
  ActionView::Helpers::Tags::CheckBox,
  ActionView::Helpers::Tags::RadioButton,
]
ActionView::Base.field_error_proc = Proc.new do |tag, instance|
  if FRIDGE_FIELD_ERROR_IGNORE_CLASSES.any? { |c| instance.kind_of?(c) }
    tag.html_safe
  else
    attribute = instance.instance_variable_get(:@method_name)
    messages = instance.object.errors.full_messages_for(attribute).join('<br>')
    bootstrapped = <<-"HTML"
<div class="field_with_errors">
  #{tag}
  <div class="invalid-feedback">#{messages}</div>
</div>
    HTML
    bootstrapped.html_safe
  end
end
