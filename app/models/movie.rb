class Movie < ApplicationRecord
  has_and_belongs_to_many :directors
  has_and_belongs_to_many :actors
  has_and_belongs_to_many :filming_locations
  has_many :reviews, dependent: :destroy

  scope :with_average_rating, -> {
    left_joins(:reviews)
      .select('movies.id, movies.title, movies.description, movies.year, AVG(reviews.stars) AS average_rating')
      .group('movies.id')
      .order('average_rating DESC')
  }

  scope :search_by_actor, ->(actor_name) {
    joins(:actors)
      .left_joins(:reviews)
      .where('actors.name LIKE ?', "%#{actor_name}%")
      .select('movies.id, movies.title, movies.description, movies.year, AVG(reviews.stars) AS average_rating')
      .group('movies.id')
      .order('average_rating DESC')
  }

  def average_rating
    reviews.average(:stars).to_f.round(2)
  end
end
