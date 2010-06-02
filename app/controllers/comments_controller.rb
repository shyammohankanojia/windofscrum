class CommentsController < ApplicationController
  before_filter :require_user
  before_filter :resolve_story, :only => [:index, :new, :create]

  def index
    @comments = @story.comments
  end
  def show
    @comment = Comment.find(params[:id])
  end
  def new
    @comment = @story.comments.build
    if params[:reply_to]
      @comment.comment_id= params[:reply_to]
    end
  end
  def create
    @comment = @story.comments.build(params[:comment])
    @comment.user_name= @current_user.name
    @comment.creation_date= Time.new
    if @comment.save
      flash[:notice] = 'Comment was successfully created.'
      redirect_to comment_path(@comment)
    else
      render :action => "new"
    end
  end
  def edit
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
  end
  def update
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      redirect_to post_comment_url(@post, @comment)
    else  render :action => "edit"
    end
  end
  def destroy
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to post_comments_path(@post) }
      format.xml { head :ok }
    end
  end

  private

  def resolve_story
    @story= Story.find(params[:story_id])
  end
end
