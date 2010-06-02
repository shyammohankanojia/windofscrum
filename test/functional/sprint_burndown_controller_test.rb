require File.dirname(__FILE__) + '/../test_helper'

# Re-raise errors caught by the controller.
class SprintBurndownController; def rescue_action(e) raise e end; end

class SprintBurndownControllerTest < ActionController::TestCase

  def setup
    UserSession.create(users(:oliver))
  end

  def test_should_get_json_data
    sprint= sprints(:app_skeleton)
    get 'show', :sprint_id => sprint.id

    assert_response :success

    expected= expected()
    actual= ActiveSupport::JSON.decode(@response.body)
    assert_equal expected, actual
  end

  def expected
        data= Hash.new
    data['title']= {'text' => "app_skeleton burndown", 'style' => '{font-size: 20px; color:#0000ff; font-family: Verdana; text-align: center;}' }
    data['elements']= [
      {
        'type' => 'line',
        'values' => [27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 27, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25],
        'dot-style' => 
          {
            'type' => "solid-dot",
            'dot-size'=> 3,
            'halo-size'=> 1,
            'colour'=> '#3D5C56'
          },
        'width' => 2,
        'colour' => '#3D5C56'
      }]
    data['x_axis']=
    {
      'stroke' => 1,
      'tick_height' =>10,
      'colour' => '#d000d0',
      'grid_colour' => '#00ff00',
      'labels' =>
      {
        'labels' => ['2009/07/27', '2009/07/28', '2009/07/29', '2009/07/30', '2009/07/31', '2009/08/01', '2009/08/02', '2009/08/03', '2009/08/04', '2009/08/05', '2009/08/06', '2009/08/07', '2009/08/08', '2009/08/09', '2009/08/10', '2009/08/11', '2009/08/12', '2009/08/13', '2009/08/14', '2009/08/15', '2009/08/16', '2009/08/17', '2009/08/18', '2009/08/19', '2009/08/20', '2009/08/21', '2009/08/22', '2009/08/23', '2009/08/24', '2009/08/25', '2009/08/26', '2009/08/27', '2009/08/28', '2009/08/29', '2009/08/30', '2009/08/31'],
        'rotate' => 90
      }
    }
    data['y_axis']=
    {
      'stroke' => 4,
      'tick_length' => 3,
      'colour' => '#d000d0',
      'grid_colour' => '#00ff00',
      'offset' => 0,
      'min' => 0,
      'max' => 27
    }
    data
  end
end
