class CsvMoviesImportWorker
  include Sidekiq::Worker

  def perform(chunk)
    chunk.each do |row|
      MovieImporter.new(row).process
    end
  end
end
