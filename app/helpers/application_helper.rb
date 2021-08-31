module ApplicationHelper
  ALERT_TYPE = {
    'notice' => 'success',
    'error' => 'danger',
    'alert' => 'primary'
  }.with_indifferent_access.freeze

  def render_alerts
    flash.map do |type, message|
      "<div class=\"alert alert-#{ALERT_TYPE[type]}\ alert-dismissible fade show\" role=\"alert\">" \
        "#{message}" \
        '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' \
      '</div>'
    end.join('').html_safe
  end
end
