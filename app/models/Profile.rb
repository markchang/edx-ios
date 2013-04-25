class Profile
  PROPERTIES = [:username, :name, :email, :courses]
  PROPERTIES.each { |prop|
    attr_accessor prop
  }

  def initialize(attributes = {})
    attributes.each { |key, value|
      self.send("#{key}=", value) if PROPERTIES.member? key.to_sym
    }
  end

  def courses
    @courses ||= []
  end

  def courses=(courses)
    if courses.first.is_a? Hash
      courses = courses.collect { |course| Course.new(course) }
    end

    courses.each { |course|
      if not course.is_a? Course
        raise "Wrong class for attempted Course #{course.inspect}"
      end
    }

    @courses = courses
  end

  def self.test_login(&block)
    username = App::Persistence['username']
    password = App::Persistence['password']

    BW::HTTP.get("http://lms.dev:8000/api/profile/" + username + "/?format=json",
       {credentials: {username: username, password: password}}) do |response|
      if response.ok?
        block.call(true)
      else
        block.call(false)
      end
    end
  end

  def self.get(&block)
    username = App::Persistence['username']
    password = App::Persistence['password']

    BW::HTTP.get("http://lms.dev:8000/api/profile/" + username + "/?format=json",
       {credentials: {username: username, password: password}}) do |response|

      if response.ok?
        result_data = BW::JSON.parse(response.body.to_str)
        p result_data
        profile = Profile.new(result_data)
        block.call(profile)
      else
        App.alert(response.error_message)
      end
    end
  end


end