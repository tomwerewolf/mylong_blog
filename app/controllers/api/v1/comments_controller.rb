module Api
  module V1
    class CommentsController < ApiBaseController
      def create
        @article = load_article
        @comment = @article.comments.new(comment_params)
        @comment.user_id = current_user.id
        @comment.save
        render json: @article.comments
      end

      def destroy
        @article = load_article
        @comment = load_comment
        @comment.destroy if author?(@comment)
        render json: @article.comments
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
  end
end
