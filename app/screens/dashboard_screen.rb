class DashboardScreen < ProMotion::TableScreen
  title "edX"
  searchable placeholder: "Filter Courses"

  @table_data = []

  def on_load
  end

  def will_appear
  end

  def on_appear
    get_profile
  end

  def table_data
    @table_data
  end

  def show_course(arguments)
    p arguments[:course_id]
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
    end
  end

end