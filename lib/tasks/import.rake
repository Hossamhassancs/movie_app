require 'csv'

namespace :import do
  desc "Import movies and reviews from CSV"
  task movies_and_reviews: :environment do
    movie_file = Rails.root.join('lib', 'seeds', 'movies.csv')
    review_file = Rails.root.join('lib', 'seeds', 'reviews.csv')

    import_csv_in_batches(movie_file, 'CsvMoviesImportWorker')
    import_csv_in_batches(review_file, 'CsvReviewsImportWorker')
  end

  def import_csv_in_batches(file_path, worker_class)
    batch_size = 100
    batch = []

    CSV.foreach(file_path, headers: true) do |row|
      batch << row.to_h

      if batch.size >= batch_size
        Object.const_get(worker_class).perform_async(batch)
        batch = []
      end
    end

    Object.const_get(worker_class).perform_async(batch) unless batch.empty?
  end
end
