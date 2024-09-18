class Public::PostCommentsController < ApplicationController
  before_action :authenticate_member!
  
  def create
    @post = Post.find(params[:post_id])
    @post_comment = current_member.post_comments.new(post_comment_params)
    @post_comment.post = @post
    if @post_comment.save
      respond_to do |format|
        format.html { redirect_to post_path(@post) }
        format.js   # Ajaxリクエストの場合
      end
    else
      render 'public/posts/show'
    end
  end
  
  def destroy
    @post = PostComment.find(params[:id]).post
    @post_comment = PostComment.find(params[:id])
    if @post_comment.member == current_member
      @post_comment.destroy
      respond_to do |format|
        format.html { redirect_to post_path(@post), notice: 'コメントを削除しました。' }
        format.js   # Ajaxリクエストの場合
      end
    else
      redirect_to post_path(@post), alert: 'コメントの削除に失敗しました。'
    end
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end