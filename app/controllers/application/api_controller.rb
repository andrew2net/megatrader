class Application::ApiController < ApplicationController
  skip_before_action :authenticate
  protect_from_forgery except: :license

  def tools
    g = ToolGroup.order(:position).select :id, :name
    t = ToolSymbol.joins(:tool_group).reorder('position, tool_symbols.name')
      .select(%{ tool_symbols.id, tool_symbols.name, tool_symbols.full_name,
    tool_group_id g_id })
    render json: { groups: g, tools: t }
  end

  def correlations
    time_frame = TimeFrame.find_by name: params[:timeFrame]
    sql = %{
    SELECT row_tool_symbol_id r, col_tool_symbol_id c, value, weight_1, weight_2,
    tc.name symbol_1, tr.name symbol_2
    FROM correlations cr
    LEFT JOIN pairs p ON
      p.tool_symbol_1_id IN (row_tool_symbol_id,col_tool_symbol_id) AND
      p.tool_symbol_2_id IN (row_tool_symbol_id,col_tool_symbol_id) AND
      p.time_frame_id=cr.time_frame_id
    JOIN tool_symbols tr ON tr.id=row_tool_symbol_id
    JOIN tool_symbols tc ON tc.id=col_tool_symbol_id
    WHERE cr.time_frame_id=:time_frame_id}
    query = ActiveRecord::Base.send('sanitize_sql_array',
                                    [sql, {time_frame_id: time_frame.id}])
    correlations = {}
    # Correlation.select('row_tool_symbol_id r, col_tool_symbol_id c, value')
    #   .where(time_frame_id: time_frame.id).each do |corr|
    ActiveRecord::Base.connection.send('select_all', query).each do |corr|
      # s_ids = [corr.r, corr.c]
      # pair = Pair.where(time_frame_id: time_frame.id, tool_symbol_1_id: s_ids,
      #           tool_symbol_2_id: s_ids).first
      correlations[corr['r']] = {} unless correlations[corr['r']]
      d = { value: corr['value'] }
      d.merge!({
        symbol_1: corr['symbol_1'],
        weight_1: corr['weight_1'],
        symbol_2: corr['symbol_2'],
        weight_2: corr['weight_2']
      }) # if pair
      correlations[corr['r']][corr['c']] = d
    end
    render json: correlations
  end

  def tool_symbols
    tool_sybols = ToolSymbol.pluck :name
    render json: tool_sybols
  end

  def spread
    time_frame = TimeFrame.find_by name: params[:time_frame]
    if result = Spread.chart_data(time_frame, params[:symbols])
      render json: result
    else
      render nothing: true
    end
  end

  def pairs
    render json: Pair.get_pairs(params[:time_frame], params[:symbols],
                                params[:page])
  end

  def license
    license = License.where(blocked: false).find_by(text: params[:l])
    if license
      if license.date_end and license.date_end < Date.today
        render json: { m: 'License is expired' }, status: :not_found
      elsif license.key.present? and license.key != params[:k]
        render json: {m: 'Bad key'}, status: :not_found
      else
        b = license.resp_data params[:a]
        LicenseLog.create ip: request.remote_ip, created_at: DateTime.now,
          license_id: license.id
        render json: {b: b, k: license.key}
      end
    else
      render json: {m: 'License not found'}, status: :not_found
    end
  end

  def download
    respond_to do |format|
      format.html do
        if (file_path = Download.file_path download_params)
          send_file file_path, filename: params[:file]
        else
          head :not_found
        end
      end
      format.json { render json: !Download.file_path(download_params).blank? }
    end
  end

  def webinars
    I18n.locale = params[:locale]
    render json: Webinar.with_translations(params[:locale]).select(:id, :name)
  end

  def webinar_reg
    user = User.find_or_initialize_by email: params[:email]
    user.locale = params[:locale]
    user.send_news = params[:send_news]
    user.save
    user_webinar = UserWebinar.create user_id: user.id,
      webinar_id: params[:webinar_id]
    UserMailer.webinar_reg_email(user_webinar).deliver_later
    head :ok
  end

  private
  def download_params
    params.permit(:token, :file).symbolize_keys
  end
end
