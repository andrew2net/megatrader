class Download < ActiveRecord::Base
  belongs_to :user

  def self.file_path(token:, file:)
    filename = URI.decode file

    # Sanitize filename.
    filename.gsub!(/[^0-9A-z\.], '_'/)

    filename = "Download/#{filename}"

    # Check if file exists and token valid. Return false if not.
    return false unless File.exists?(filename) and
      (download = find_by token: token) and
      (download.updated_at + 1.day) > DateTime.now

    filename
  end
end
