class MovieImporter
  def initialize(row)
    @row = row
  end

  def process
    process_directors
    process_actors
    process_filming_locations
    process_movie
  end

  private

  def process_directors
    @directors = @row['Director'].split(',').map do |director_name|
      Director.find_or_create_by(name: director_name.strip)
    end
  end

  def process_actors
    @actors = @row['Actor'].split(',').map do |actor_name|
      Actor.find_or_create_by(name: actor_name.strip)
    end
  end

  def process_filming_locations
    location_name = @row['Filming location'].strip
    country_name = @row['Country'].strip
    @filming_location = FilmingLocation.find_or_create_by(location: location_name, country: country_name)
  end

  def process_movie
    movie = Movie.find_or_create_by(
      title: @row['Movie'],
      description: @row['Description'],
      year: @row['Year'].to_i
    )
    
    @directors.each { |director| movie.directors << director unless movie.directors.include?(director) }
    @actors.each { |actor| movie.actors << actor unless movie.actors.include?(actor) }
    movie.filming_locations << @filming_location unless movie.filming_locations.include?(@filming_location)
  end
end
  