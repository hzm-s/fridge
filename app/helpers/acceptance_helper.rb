# typed: false
module AcceptanceHelper
  def render_acceptance_satisfaction_status(criterion)
    classes = 'acceptance-criterion__status'
    if criterion.satisfied?
      classes << ' acceptance-criterion__status--satisfied far fa-check-circle'
    else
      classes << ' far fa-circle'
    end

    content_tag(:i, nil, class: classes)
  end

  def render_acceptance_criterion_content(criterion, opts)
    data = {}
    data.merge!("satisfied-acceptance-criterion-#{criterion.number}" => 1) if criterion.satisfied?

    content_tag(:span, criterion.content, class: opts[:class], data: data)
  end
end
