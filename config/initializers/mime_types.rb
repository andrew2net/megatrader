# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf

# Fixes mail preview not working properly for mails with attachments.
# Changeset https://github.com/rails/rails/commit/350d272d6cd6fbbb127133773c79c3c17e4216f0
# See discussion in https://github.com/rails/rails/issues/14435
require 'rails/mailers_controller'
require 'rails/application_controller'

class Rails::MailersController < Rails::ApplicationController
  def find_preferred_part(*formats)
    formats.each do |format|
      if part = @email.find_first_mime_type(format)
        return part
      end
    end

    if formats.any?{ |f| @email.mime_type == f }
      @email
    end
  end

  def find_part(format)
    if part = @email.find_first_mime_type(format)
      part
    elsif @email.mime_type == format
      @email
    end
  end
end