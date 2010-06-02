# 
# Generates the data for the sprint progress bar at show sprint view.
#

class SprintProgressController < ApplicationController

  before_filter :require_user

  def show
    sprint= Sprint.find(params[:sprint_id])

    now= Time.new.to_date
    remaining_work= sprint.remaining_work_on_date(now)
    work_to_be_done= 0
    sprint.backlog.each do |s|
      work_to_be_done+= (s.initial_estimate ? s.initial_estimate : 0)
    end
    work_already_done= work_to_be_done - remaining_work

    total_days= (sprint.release_date  - sprint.start_date) + 1
    now= sprint.release_date + 1 if sprint.release_date < now
    days_until_now= now - sprint.start_date
    today_percent = (days_until_now.to_f / total_days.to_f)*100

    if (!sprint.backlog.empty?)
      work_already_done_percent= (work_already_done.to_f/work_to_be_done.to_f)*100
    else
      work_already_done_percent= 0
    end

    done_values= {:left => 0, :right => work_already_done_percent, :colour => '#00FF00'}
    delay_values= {:left => [work_already_done_percent, today_percent].min, :right => [work_already_done_percent, today_percent].max, :colour => '#FF0000'}
    remaining_values= {:left => [work_already_done_percent, today_percent].max, :right => 100, :colour => 'grey'}

#{ "elements": [ { "type": "hbar",
#      "values": [ { "left": 0, "right": 4 }, { "left": 4, "right": 8 }, { "left": 8, "right": 11, "tip": "#left# to #right# Sep to Dec (#val# months)" } ],
#      "colour": "#86BBEF",
#      "tip": "Months: #val#" } ],
#  "title": { "text": "Sprint progress" },
#  "x_axis": { "offset": false, "labels": { "labels": [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ] } },
#  "y_axis": { "offset": 1, "labels": [ "Pending stories", "Delay", "Done stories" ] } }

    data= Hash.new
    data[:title]= {:text => "Sprint progress", :style => '{font-size: 20px; color:#0000ff; font-family: Verdana; text-align: center;}' }
    data[:elements]= [
      {
        :type => 'hbar',
        :values => [done_values, delay_values, remaining_values]
      }]
    data['x_axis']=
    {
      :offset=> false,
      'tick_height' =>10,
      :colour => '#d000d0',
      'grid_colour' => '#00ff00',
      :min => 0,
      :steps => 10,
      :max => 100
    }
    data['y_axis']=
    {
      :offset=> 1,
      'tick_length' => 3,
      :colour => '#d000d0',
      'grid_colour' => '#00ff00',
      :labels => ['Remaining', 'Delay', 'Done']
    }

    respond_to do |format|
      format.json { render :json => data.to_json }
    end
  end
end