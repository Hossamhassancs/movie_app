class CreateJoinTableMoviesFilmingLocations < ActiveRecord::Migration[7.1]
  def change
    create_join_table :movies, :filming_locations do |t|
      # t.index [:movie_id, :filming_location_id]
      # t.index [:filming_location_id, :movie_id]
    end
  end
end
