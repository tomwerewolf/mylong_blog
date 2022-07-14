class CommentsController < ApplicationBaseController
  def create
    @article = load_article
    @comment = @article.comments.new(comment_params)
    @comment.user_id = current_user.id
    @comment.save
    redirect_to article_path(@article)
  end

  def destroy
    @article = load_article
    @comment = load_comment
    @comment.destroy
    redirect_to article_path(@article), status: 303
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_article
    Article.find(params[:article_id])
  end

  def load_comment
    Comment.find(params[:id])
  end  
end
