# typed: false
module ResponseBodySupport
  def data_attr(name, value, is_js = false)
    if is_js
      %Q(#{name}=\\"#{value}\\")
    else
      %Q(#{name}="#{value}")
    end
  end
end

RSpec.configure do |c|
  c.include ResponseBodySupport, type: :request
end
