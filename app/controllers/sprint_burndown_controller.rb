class SprintBurndownController < ApplicationController
  before_filter :require_user

  def show
    sprint= Sprint.find(params[:sprint_id])

    sprint_dates= Array.new
    remaining_work_by_date= Array.new
    now= Time.new.to_date
    actual_date= sprint.release_date
    while (actual_date >= sprint.start_date)
      sprint_dates << actual_date
      if (actual_date < now)
        remaining_work_by_date << sprint.remaining_work_on_date(actual_date)
      end
      actual_date= actual_date - 1.day
    end
    sprint_dates.reverse!
    remaining_work_by_date.reverse!

    data= Hash.new
    data[:title]= {:text => "#{sprint.name} burndown", :style => '{font-size: 20px; color:#0000ff; font-family: Verdana; text-align: center;}' }
    data[:elements]= [
      {
        :type => 'line',
        :values => remaining_work_by_date,
        'dot-style' => 
          {
            :type => "solid-dot",
            'dot-size'=> 3,
            'halo-size'=> 1,
            :colour=> '#3D5C56'
          },
        :width => 2,
        :colour => '#3D5C56'
      }]
    data['x_axis']=
    {
      :stroke => 1,
      'tick_height' =>10,
      :colour => '#d000d0',
      'grid_colour' => '#00ff00',
      :labels =>
      {
        #:labels => ["January","February","March","April","May","June","July","August","Spetember"]
        :labels => sprint_dates,
        :rotate => 90
      }
    }
    data['y_axis']=
    {
      :stroke => 4,
      'tick_length' => 3,
      :colour => '#d000d0',
      'grid_colour' => '#00ff00',
      :offset => 0,
      :min => 0,
      :max => remaining_work_by_date.max
    }

    respond_to do |format|
      format.json { render :json => data.to_json }
    end
  end
end
