class Post < ActiveRecord::Base
  def self.popular_posts
    Post.where(popular_flag: true).order(:view)
  end
end
