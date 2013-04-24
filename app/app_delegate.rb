class AppDelegate < ProMotion::AppDelegateParent
  def on_load(application, options)
    open_screen DashboardScreen.new(nav_bar: true)
  end
end
