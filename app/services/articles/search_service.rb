module Articles
  class SearchService
    def initialize args = {}
      @articles = args[:articles]
      @params = args[:params]
    end
    
    def call
      #binding.pry      
      @articles = @articles.search_title(params[:title]) if params[:title].present?
      @articles = @articles.search_cat(params[:category_id]) if params[:category_id].present?
      @articles = @articles.search_range(params[:date_from], params[:date_to]) if params[:date_from].present? && params[:date_to].present?
      
      @articles 
    end
    
    private
    attr_reader :params

  end  
end  