class ResizeImageJob < ApplicationJob
  queue_as :default

  def perform(article) 
    image = article.image
    image.variant(resize_to_limit: [100, 100])
    image.save  
  end 
end  