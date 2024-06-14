require 'csv'

namespace :import do
  desc 'Import movies and reviews from CSV'
  task movies_and_reviews: :environment do
    movie_file = Rails.root.join('lib', 'seeds', 'movies.csv')
    review_file = Rails.root.join('lib', 'seeds', 'reviews.csv')

    # Import Directors
    directors = {}
    CSV.foreach(movie_file, headers: true) do |row|
      director_names = row['Director'].split(',').map(&:strip)
      director_names.each do |director_name|
        directors[director_name] ||= Director.find_or_create_by(name: director_name)
      end
    end

    # Import Actors
    actors = {}
    CSV.foreach(movie_file, headers: true) do |row|
      actor_names = row['Actor'].split(',').map(&:strip)
      actor_names.each do |actor_name|
        actors[actor_name] ||= Actor.find_or_create_by(name: actor_name)
      end
    end

    # Import Filming Locations
    filming_locations = {}
    CSV.foreach(movie_file, headers: true) do |row|
      location_names = row['Filming location'].split(',').map(&:strip)
      location_names.each do |location_name|
        filming_locations[location_name] ||= FilmingLocation.find_or_create_by(location: location_name, country: row['Country'])
      end
    end

    # Import Movies
    CSV.foreach(movie_file, headers: true) do |row|
      movie = Movie.find_or_create_by(
        title: row['Movie'],
        description: row['Description'],
        year: row['Year'].to_i
      )

      director_names = row['Director'].split(',').map(&:strip)
      director_names.each do |director_name|
        movie.directors << directors[director_name] unless movie.directors.include?(directors[director_name])
      end

      actor_names = row['Actor'].split(',').map(&:strip)
      actor_names.each do |actor_name|
        movie.actors << actors[actor_name] unless movie.actors.include?(actors[actor_name])
      end

      location_names = row['Filming location'].split(',').map(&:strip)
      location_names.each do |location_name|
        movie.filming_locations << filming_locations[location_name] unless movie.filming_locations.include?(filming_locations[location_name])
      end
    end

    # Import Reviews
    CSV.foreach(review_file, headers: true) do |row|
      movie = Movie.find_by(title: row['Movie'])
      if movie
        movie.reviews.find_or_create_by(
          user: row['User'],
          stars: row['Stars'].to_i,
          review: row['Review']
        )
      end
    end
  end
end
