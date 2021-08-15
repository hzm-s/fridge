# typed: false
module SblHelper
  TASK_STATUS_CLASSES = {
    todo: 'fa fa-minus-circle',
    wip: 'far fa-circle',
    done: 'far fa-check-circle',
    wait: 'fa fa-exclamation-circle',
  }

  TASK_ACTION_CLASSES = {
    start_task: 'fas fa-play',
    complete_task: 'fas fa-check',
    suspend_task: 'fas fa-pause',
    resume_task: 'fas fa-play',
  }

  def sbl_task_list_classes(tasks)
    classes = %w(sbi-task__list)
    classes << 'sbi-task__list--empty' if tasks.empty?
    
    classes.join(' ')
  end

  def sbl_item_grip_css_classes(can_move)
    return 'sbl-item__grip js-sortable-handle' if can_move

    "sbl-item__grip sbl-item__grip--disabled"
  end

  def render_sbl_task_status(task)
    action = task.status.next_activity.to_s
    disabled = action.size == 0

    button_to(
      work_task_status_path(global_task_params(task, by: action)),
      remote: true,
      method: :patch,
      class: 'sbi-task__status-trigger',
      disabled: disabled,
      data: with_loader({
        task_dom_id(task, "test_#{action}") => 1,
        "test_task_status_#{task.issue_id}_#{task.number}" => task.status.to_s,
      })
    ) do
      content_tag(:i, nil, class: sbl_task_status_classes(task.status.to_s))
    end
  end

  def task_action_link(task, action, html_options)
    url = work_task_status_path(global_task_params(task, type: action))
    options =
      { remote: true, method: :patch }
        .merge(html_options)
        .merge(data: { task_dom_id(task, "test_#{action}") => 1 })

    link_to(url, options) do
      concat content_tag(:i, nil, class: TASK_ACTION_CLASSES[action.to_sym], style: 'margin-right:0.3rem')
      concat t(action, scope: 'domain.task')
    end
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

  def global_task_params(task, extras = {})
    { issue_id: task.issue_id, number: task.number }.merge(extras)
  end

  def task_dom_id(task, prefix)
    "#{prefix}-#{task.issue_id}-#{task.number}"
  end

  def sbl_sortable_options(product_id, can_update)
    base = {
      controller: 'sort-list',
      sort_list_url: current_sprint_work_priority_path(product_id: product_id),
      sort_list_group: 'sbl',
    }
    return base unless can_update

    base.merge(test_change_work_priority: 1)
  end
end
