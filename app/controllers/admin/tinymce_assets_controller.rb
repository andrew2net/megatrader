class Admin::TinymceAssetsController < ApplicationController

  def create
    uploaded_io = params[:file]
    filename = "#{params[:hint]}_#{uploaded_io.original_filename}"
    File.open(Rails.root.join('public', 'images', filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end

    render json: {
               image: {
                   url: view_context.image_url(filename)
               }
           }, content_type: 'text/html'
  end
end