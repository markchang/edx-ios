class Course
  PROPERTIES = [:course_id, :description, :image_url, :is_running, :name, :root, :blocks]
  PROPERTIES.each { |prop|
    attr_accessor prop
  }

  def initialize(attributes = {})
    attributes.each { |key, value|
      self.send("#{key}=", value) if PROPERTIES.member? key.to_sym
    }
  end

  def get(&block)
    username = App::Persistence['username']
    password = App::Persistence['password']

    url = "http://lms.dev:8000/api/course/" + course_id + "/?format=json"
    BW::HTTP.get(url,{
        credentials: {username: username, password: password}
      }) do |response|

      SVProgressHUD.dismiss
      
      if response.ok?
        result_data = BW::JSON.parse(response.body.to_str)
        self.root = result_data['root']
        self.blocks = result_data['blocks']
        block.call(self)
      else
        # p response
        App.alert(response.error_message)
      end
    end
  end

end