class ActionView::TestCase::TestController
  def default_url_options(options={})
    { locale: I18n.locale }
  end
end

class ActionDispatch::Routing::RouteSet
  def default_url_options(options={})
    { locale: I18n.locale }
  end
end
