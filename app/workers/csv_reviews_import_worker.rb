class CsvReviewsImportWorker
  include Sidekiq::Worker

  def perform(chunk)
    chunk.each do |row|
      ReviewImporter.new(row).process
    end
  end
end