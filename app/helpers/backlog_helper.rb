module BacklogHelper
  #
  #
  #
  # BACKLOG UTILS
  #
  #
  #
  #
  #
  #

  def compute_estimated_days(backlog)
    sum= 0
    backlog.each { |s| sum+= (s.initial_estimate ? s.initial_estimate : 0) }
    sum
  end

  #
  #
  #
  # BACKLOG LIST
  #
  #
  #
  #
  #
  #

  #
  # Action :unassign requires backlog.js to be loaded.
  #
  # @param stories the list of story items
  # @param actions a list with the action to show.
  def list_backlog(stories, actions=[])

    render :partial => 'backlog/list', :locals => {:backlog=> stories, :actions => actions}
  end

  def story_row(story, actions=[])
    row= <<STANDARD_TABLE_DATA
      <td>#{story.name}</td>
      <td>#{story.importance}</td>
      <td>#{story.initial_estimate}</td>
      <td>#{story.how_to_demo}</td>
      <td>#{story.notes}</td>
      <td>#{story.start_date}</td>
      <td>#{story.finished}</td>
STANDARD_TABLE_DATA

    if (actions.detect(nil) { |a| a == :show })
      row << '<td>'  << link_to('Show', story_path(story)) << '</td>'
    end
    if (actions.detect(nil) { |a| a == :edit })
      row << '<td>' << link_to('Edit', edit_story_path(story)) << '</td>'
    end
    if (actions.detect(nil) { |a| a == :delete })
      row << '<td>' << link_to('Destroy', story_path(story), :confirm => 'Are you sure?', :method => :delete) << '</td>'
    end
    if (actions.detect(nil) { |a| a == :unassign })
      js= "unassign(this);window.location.reload();return false;"
      row << '<td>' << link_to('Unassign', sprint_assignation_path(story.sprint, story), :onclick=>js) << '</td>'
    end
    row
  end

  def show_story(story)
    div_id= "show_story_#{story.id}"

    js= 'Modalbox.show(this.href, {title:this.innerHTML, width:1024});Event.stop(event);return false;'
    url= sprint_story_path(story.sprint, story)
    link= link_to "#{story.name} (#{story.initial_estimate} days)", url, :ondblclick=> js, :onclick => 'Event.stop(event)'
    <<SHOW_STORY
    <span title="(importance=#{story.importance}/estimate=#{story.initial_estimate})">#{link}</span>
SHOW_STORY
#    <<SHOW_STORY
#    <span onmouseover="$('#{div_id}').show()" onmouseout="$('#{div_id}').hide()">#{story.name} (importance=#{story.importance}/estimate=#{story.initial_estimate})</span>
#    <div id="#{div_id}" style="display:none;background-color:yellow;">#{show_story_details(story)}</div>
#SHOW_STORY
  end

  def show_story_details(story)
    <<SHOW_STORY_DETAILS
<p>
  <b>Importance:</b> #{story.importance}
</p>

<p>

  <b>Initial estimate:</b> #{story.initial_estimate}
</p>

<p>
  <b>How to demo:</b> <pre>#{story.how_to_demo}</pre>
</p>

<p>
  <b>Notes:</b> <pre>#{story.notes}</pre>
</p>

<p>
  <b>Finished:</b> #{story.finished}
</p>
SHOW_STORY_DETAILS
  end
end
