# typed: false
module SblHelper
  TASK_STATUS_CLASSES = {
    todo: 'fa fa-minus-circle',
    wip: 'far fa-circle',
    done: 'far fa-check-circle'
  }

  def sbl_task_list_classes(tasks)
    classes = %w(sbi-task__list)
    classes << 'sbi-task__list--empty' if tasks.empty?
    
    classes.join(' ')
  end

  def sbl_item_grip_css_classes(can_move)
    base = 'sbl-item__grip'
    return base if can_move

    "#{base} sbl-item__grip--disabled"
  end

  def render_sbl_task_status(task)
    content_tag(
      :i,
      nil,
      class: sbl_task_status_classes(task.status),
      data: { "test_task_status_#{task.issue_id}_#{task.number}" => task.status }
    )
  end

  def sbl_task_status_classes(status)
    classes = %w(sbi-task__status)
    classes << TASK_STATUS_CLASSES[status.to_sym]
    classes << "sbi-task__status--#{status}"

    classes.join(' ')
  end

  def new_task_form
    TaskForm.new
  end

  def build_task_form(task)
    TaskForm.new(content: task.content)
  end

  def global_task_params(task)
    { issue_id: task.issue_id, number: task.number }
  end

  def task_dom_id(task, prefix)
    "#{prefix}-#{task.issue_id}-#{task.number}"
  end
end
