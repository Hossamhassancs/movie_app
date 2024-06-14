class MoviesController < ApplicationController
  before_action :set_movie, only: [:show]

  def index
    @movies = if params[:actor].present?
                Movie.search_by_actor(params[:actor])
              else
                Movie.with_average_rating
              end
              .page(params[:page])

    @movies_with_details = @movies.map { |movie| build_movie_details(movie) }
  end

  def show
    @directors = @movie.directors.pluck(:name).join(", ")
    @actors = @movie.actors.pluck(:name).join(", ")
    @filming_locations = @movie.filming_locations.pluck(:location).join(", ")
    @countries = @movie.filming_locations.pluck(:country).join(", ")
    @reviews = @movie.reviews
  end

  private

  def set_movie
    @movie = Movie.includes(:directors, :actors, :filming_locations, :reviews).find(params[:id])
  end

  def build_movie_details(movie)
    {
      movie: movie,
      directors: movie.directors.pluck(:name).join(", "),
      actors: movie.actors.pluck(:name).join(", "),
      filming_locations: movie.filming_locations.pluck(:location).join(", "),
      countries: movie.filming_locations.pluck(:country).join(", ")
    }
  end
end
