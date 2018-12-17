class Admin::DashboardNextController < Admin::AdminController
  def index
    data = AdminDashboardNextIndexData.fetch_cached_stats

    if SiteSetting.version_checks?
      data.merge!(version_check: DiscourseUpdates.check_version.as_json)
    end

    render json: data
  end

  def moderation; end
  def security; end
  def reports
    reports_methods = ['page_view_total_reqs'] +
      ApplicationRequest.req_types.keys
        .select { |r| r =~ /^page_view_/ && r !~ /mobile/ }
        .map { |r| r + "_reqs" } +
      Report.singleton_methods.grep(/^report_(?!about)/)

    reports = reports_methods.map do |name|
      type = name.to_s.gsub('report_', '')
      description = I18n.t("reports.#{type}.description", default: '')

      {
        type: type,
        title: I18n.t("reports.#{type}.title"),
        description: description.presence ? description : nil,
      }
    end

    render_json_dump(reports: reports.sort_by { |report| report[:title] })
  end

  def general
    render json: AdminDashboardNextGeneralData.fetch_cached_stats
  end
end
