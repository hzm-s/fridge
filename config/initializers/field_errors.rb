# typed: ignore
ActionView::Base.field_error_proc = Proc.new do |tag, instance|
  if instance.kind_of?(ActionView::Helpers::Tags::Label)
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
