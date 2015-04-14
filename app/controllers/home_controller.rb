class HomeController < ApplicationController
  def index
  end

  def export_summary
    render xlsx: 'summary_report', filename: 'summary_report.xlsx', locals: { import_data: Trade.summary_import, export_data: Trade.summary_export}
  end
end
