class Block
  PROPERTIES = [:category, :children, :definition, :metadata]
  PROPERTIES.each { |prop|
    attr_accessor prop
  }

  def initialize(attributes = {})
    attributes.each { |key, value|
      self.send("#{key}=", value) if PROPERTIES.member? key.to_sym
    }
  end

  def self.get(&block)
    url = "http://lms.dev:8000/api/course/" + course_id + "/?format=json"
    BW::HTTP.get("") do |response|
      if response.ok?
        result_data = BW::JSON.parse(response.body.to_str)
        p result_data
        course = Course.new(result_data)
        block.call(profile)
      else
        App.alert(response.error_message)
      end
    end
  end

end