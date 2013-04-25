class DashboardScreen < ProMotion::TableScreen
  title "edX"
  searchable placeholder: "Filter Courses"

  @table_data = []

  def on_load
    @refresh = UIRefreshControl.alloc.init
    @refresh.attributedTitle = NSAttributedString.alloc.initWithString("Pull to Refresh")
    @refresh.addTarget(self, action:'refreshView:', forControlEvents:UIControlEventValueChanged)
    self.refreshControl = @refresh

    on_refresh do
      get_profile
    end

    set_nav_bar_left_button "Sign Out", action: :sign_out
  end

  def on_appear
    # check username password
    username = App::Persistence['username']
    password = App::Persistence['password']

    if username.nil? or password.nil? then
      open LoginScreen.new, modal: true
    else
      get_profile
    end
  end

  def table_data
    @table_data
  end

  def show_course(arguments)
    open_screen VideosScreen.new(course: arguments[:course])
  end

  def get_profile
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
      end_refreshing
    end
  end

  def sign_out
    App::Persistence['username'] = nil
    App::Persistence['password'] = nil

    open LoginScreen.new, modal: true
  end


  # UIRefreshControl Delegates
  def refreshView(refresh)
    refresh.attributedTitle = NSAttributedString.alloc.initWithString("Refreshing data...")
    @on_refresh.call if @on_refresh
  end

  def on_refresh(&block)
    @on_refresh = block
  end

  def end_refreshing
    return unless @refresh

    @refresh.attributedTitle = NSAttributedString.alloc.initWithString("Last updated on #{Time.now.strftime("%H:%M:%S")}")
    @refresh.endRefreshing
  end
end