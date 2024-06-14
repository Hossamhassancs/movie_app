class ReviewImporter

  def initialize(row)
    @row = row
  end

  def process
    movie = Movie.find_by(title: @row['Movie'])
    return unless movie

    movie.reviews.find_or_create_by(
      user: @row['User'],
      stars: @row['Stars'].to_i,
      review: @row['Review']
    )
  end
end
  