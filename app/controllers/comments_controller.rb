class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  def self.refresh
    puts "load dianping ... #{Time.now}"
          
    begin
      thing = YAML.load_file('config/idlist.yml')
      idlist = thing["Dianping"].split
    rescue Exception => e
      idlist = []
    end

    idlist ||= []
    idlist.each do |id|
      comment = Comment.create_by_member id
      db_comment = Comment.find_by_member id
      if db_comment
        db_comment.merge comment
      else
        db_comment = comment
      end
      db_comment.save
      sleep 0.5
    end
    puts "load dianping done ... #{Time.now}"
  end
end
