class DashboardScreen < ProMotion::TableScreen
  title "edX"
  searchable placeholder: "Filter Courses"

  @table_data = []

  def on_load
    set_nav_bar_right_button "Refresh", action: :get_profile
    set_nav_bar_left_button "Sign Out", action: :sign_out
  end

  def will_appear
  end

  def on_appear
    # check username password
    username = App::Persistence['username']
    password = App::Persistence['password']

    p "Dashboard u/p: %s %s", [username, password]

    if username.nil? or password.nil? then
      p "Opening Login Screen"
      open LoginScreen.new, modal: true
    else
      get_profile
    end
  end

  def table_data
    @table_data
  end

  def show_course(arguments)
    p arguments[:course_id]
    open_screen VideosScreen.new(course: arguments[:course])
  end

  def get_profile
    SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)

    Profile.get do |profile|
      cells = []
      profile.courses.each do |c|
        cells << {
          title: c.name,
          action: :show_course,
          arguments: { course: c}
        }
      end

      @table_data = [{ 
        title: "",
        cells: cells,
      }]

      update_table_data
    end
  end

  def sign_out
    App::Persistence['username'] = nil
    App::Persistence['password'] = nil

    p "Sign out"

    open LoginScreen.new, modal: true
  end

end