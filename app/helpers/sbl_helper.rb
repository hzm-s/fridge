# typed: true
module SblHelper
  TASK_PROGRESS_CLASSES = {
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

  def sbl_task_progress_classes(progress)
    classes = %w(sbi-task__progress)
    classes << TASK_PROGRESS_CLASSES[progress]
    classes << "sbi-task__progress--#{progress}"

    classes.join(' ')
  end
end
