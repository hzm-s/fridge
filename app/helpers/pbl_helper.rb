# typed: true
module PblHelper
  STATUS_FILTER_CLASSES_BASE = 'pbl__filter btn'.freeze

  def pbl_status_filter_classes(current:, filter:)
    "#{STATUS_FILTER_CLASSES_BASE} btn-#{current == filter ? '' : 'outline-'}secondary"
  end
end
