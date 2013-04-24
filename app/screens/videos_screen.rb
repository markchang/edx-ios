class VideosScreen < ProMotion::TableScreen
  attr_accessor :course

  title "Videos"
  searchable placeholder: "Filter Videos"

  @table_data = []

  def on_load
    get_videos
  end

  def will_appear
  end

  def on_appear
  end

  def table_data
    @table_data
  end

  def show_video(arguments)
    url = "http://lms.dev:8000/api/xblock/" + arguments[:definition]+ "/?format=json"
    youtube_id = ""

    BW::HTTP.get(url) do |response|
      if response.ok?
        result_data = BW::JSON.parse(response.body.to_str)
        p result_data
        youtube_id = result_data['data']
        youtube_url = "https://www.youtube.com/watch?v=" + youtube_id
        p youtube_url
        
        videos = HCYoutubeParser.h264videosWithYoutubeURL(NSURL.URLWithString(youtube_url))
        mp = MPMoviePlayerViewController.alloc.initWithContentURL(NSURL.URLWithString(videos["medium"]))
        self.presentMoviePlayerViewControllerAnimated(mp)
      else
        App.alert(response.error_message)
      end
    end
  end

  def get_videos
    SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
    
    course.get do |c|
      @table_data = get_videos_from_block(c)
      update_table_data
    end
  end

  def get_videos_from_block(course)
    section_cells = []
    
    blocks = course.blocks
    root   = blocks[course.root]

    for section_id in root['children'] do
      section = blocks[section_id]

      if section['category'] != 'chapter' then
        next
      end
      
      video_cells = []
        
      if section['metadata']['display_name'].nil? then
            section['metadata']['display_name'] = ":: no title ::"
      end

      section_cell = {title: section['metadata']['display_name'],
                      cells: video_cells}
      section_cells.push(section_cell)

      for subsection_id in section['children'] do
        subsection = blocks[subsection_id]
      

        for child in descendants(blocks, subsection_id) do
          if child['metadata']['display_name'].nil? then
            child['metadata']['display_name'] = ":: no title ::"
          end
          if child['category'] == 'video' then
            video_cells << { 
              title: child['metadata']['display_name'],
              action: :show_video,
              arguments: { definition: child['definition'] }
            }
          else
            next
          end
        end
      end
    end

    section_cells
  end

  def descendants(blocks,root)
    result = []
    stack = [root]

    while not stack.empty? do
      node_id = stack.pop
      result.push(blocks[node_id])

      for child in blocks[node_id]['children'].reverse do
        if blocks.include? child then
          stack.push(child)
        end
      end
    end

    result
  end

end