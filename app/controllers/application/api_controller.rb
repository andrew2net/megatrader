class Application::ApiController < ApplicationController
  skip_before_action :authenticate

  def tools
    g = ToolGroup.order(:position).select :id, :name
    t = ToolSymbol.joins(:tool_group).reorder('position, tool_symbols.name')
      .select(%{ tool_symbols.id, tool_symbols.name, tool_symbols.full_name,
    tool_group_id g_id })
    render json: { groups: g, tools: t }
  end

  def correlations
    time_frame = TimeFrame.find_by name: params[:timeFrame]
    correlations = {}
    Correlation .select('row_tool_symbol_id r, col_tool_symbol_id c, value')
      .where(time_frame_id: time_frame.id).each do |corr|
      correlations[corr.r] = {} unless correlations[corr.r]
      correlations[corr.r][corr.c] = corr.value
    end
    render json: correlations
  end

  def tool_symbols
    tool_sybols = ToolSymbol.pluck :name
    render json: tool_sybols
  end

  def spread
    if params[:symbols]
      days = Setting.find_by(name: params[:time_frame] + '_period').value
      date_time = (Date.today - days.to_i)
      time_frame_id = TimeFrame.find_by name: params[:time_frame]
      spread = nil
      join = ''
      sw = []
      ToolSymbol.where(id: params[:symbols].map{|k, v| k}).each do |s|
        w = params[:symbols][s.id.to_s].gsub(',', '.').to_f
        next if w == 0
        w = w.to_s
        if spread
          sw << s.name + '.value*' + w
          join = join + %{
          JOIN spreads #{s.name} ON #{s.name}.date_time=s.date_time
          AND #{s.name}.time_frame_id=s.time_frame_id
          AND #{s.name}.tool_symbol_id=#{s.id}}
        else
          sw << 's.value*' + w
          spread = %{FROM spreads s joins WHERE s.date_time>=:date_time AND
          s.time_frame_id=:time_frame_id AND s.tool_symbol_id=#{s.id}}
        end
      end
      if spread
        spread = %{ SELECT #{sw.join '+'}, to_char(s.date_time, 'DDMMYYYYHH24MI')
        #{spread.sub 'joins', join.to_s}}
        sql = ActiveRecord::Base.send(:sanitize_sql_array,
          [spread, {date_time: date_time, time_frame_id: time_frame_id}])
        result = ActiveRecord::Base.connection.select_rows sql
        render json: result
      else
        render nothing: true
      end
    else
      render nothing: true
    end
  end
end
