module Articles
  class SearchService
    def initialize args = {}
      @articles = args[:articles]
      @params = args[:params]
    end
    
    def call      
      @articles = @articles.search_title(params[:title]) if params[:title].present?
      @articles = @articles.search_cat(params[:category_id]) if params[:category_id].present?
      @articles = @articles.search_range(params[:from_date],params[:to_date]) if params[:from_date].present? && params[:to_date].present?
      
      @articles 
    end
    
    private
    attr_reader :params

  end  
end  