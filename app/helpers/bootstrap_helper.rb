module BootstrapHelper
  def dd_trigger_options(options)
    dom_id = options.delete(:id)
    dom_class = options.delete(:class)

    opts = {
      data: {
        toggle: 'dropdown',
        display: 'static',
        'aria-haspopup' => 'true',
        'aria-expanded' => 'false'
      }
    }

    opts.merge!(id: dom_id) if dom_id
    opts.merge!(class: dom_class) if dom_class
    opts
  end

  def collapse_trigger_options(options)
    target = options.delete(:target)
    dom_class = options.delete(:class)

    opts = {
      data: {
        toggle: 'collapse'
      },
      'aria-expanded' => 'false',
      'aria-controls' => target
    }

    opts.merge!(class: dom_class) if dom_class
    opts
  end
end
