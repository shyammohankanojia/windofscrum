class BacklogController < ApplicationController
  before_filter :require_user
  
  # GET /backlog
  # GET /backlog.xml
  def index
    finished= params[:finished]

    if (!finished.nil? and finished.class == String and !finished.empty?) 
      @backlog = Story.find(:all, :conditions => ["project_id=? and finished=?", params[:project_id], finished], :order => "importance DESC")
      @unfinished= @backlog unless finished.class != String and finished
    else
      @backlog = Story.find(:all, :conditions => ["project_id=?", params[:project_id]], :order => "importance DESC")
    end
    

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @backlog.to_xml }
    end
  end

  # GET /backlog/1
  # GET /backlog/1.xml
  def show
    @story = Story.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @story.to_xml }
    end
  end

  # GET /backlog/new
  def new
    @story = Story.new
    @story.project_id= params[:project_id]
    @story.sprint_id= params[:sprint_id]
  end

  # GET /backlog/1;edit
  def edit
    @story = Story.find(params[:id])
  end

  # POST /backlog
  # POST /backlog.xml
  def create
    params[:story].merge!({:project_id => params[:project_id]})
    @story = Story.new(params[:story])

    respond_to do |format|
      if @story.save
        flash[:notice] = 'Story was successfully created.'
        format.html { redirect_to story_path(@story) }
        format.xml  { head :created, :location => story_url(@story) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @story.errors.to_xml }
      end
    end
  end

  # PUT /backlog/1
  # PUT /backlog/1.xml
  def update
    @story = Story.find(params[:id])

    respond_to do |format|
      if @story.update_attributes(params[:story])
        flash[:notice] = 'Backlog was successfully updated.'
        format.html { redirect_to story_path(@story) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @story.errors.to_xml }
      end
    end
  end

  # DELETE /backlog/1
  # DELETE /backlog/1.xml
  def destroy
    story = Story.find(params[:id])
    project= story.project
    story.destroy

    respond_to do |format|
      format.html { redirect_to project_backlog_url(project) }
      format.xml  { head :ok }
    end
  end
end
