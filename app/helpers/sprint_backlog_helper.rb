module SprintBacklogHelper
  def sprint_backlog_row(story)

    pending= pending_td story
    workingonit= workingonit_td story
    done= done_td story
    row= <<STORY_ON_BACKLOG_ROW
<tr>
  <td>#{story.importance}</td>
  <td>#{pending.first}</td>
  <td>#{workingonit.first}</td>
  <td>#{done.first}
  <script lang='text/javascript'>#{pending.last}#{workingonit.last}#{done.last}</script>
  </td>
</tr>
STORY_ON_BACKLOG_ROW

  end

  def pending_td(story)
    td= ''
    script= ''
    if (story.pending?())
      td+= sprint_backlog_show_story story
    else
      if (authz_to_update_story(story.sprint.project))
        drop_id= "drop_pending_#{story.id}"
        td+= droppable_div drop_id, 'pending'
        script+= script story.id, drop_id, 'moveStory'
      end
    end

    [td, script]
  end

  def workingonit_td(story)
    td= ''
    script= ''
    if (story.workingonit?())
      td+= sprint_backlog_show_story story
    else
      if (authz_to_update_story(story.sprint.project))
        drop_id= "drop_workingonit_#{story.id}"
        td+= droppable_div drop_id, 'workingonit'
        script+= script(story.id, drop_id, 'moveStory')
      end
    end

    [td, script]
  end

  def done_td(story)
    td= ''
    script= ''
    if (story.finished?())
      td+= sprint_backlog_show_story story
    else
      if (authz_to_update_story(story.sprint.project))
        drop_id= "drop_done_#{story.id}"
        td+= droppable_div drop_id, 'finished'
        script+= script(story.id, drop_id, 'moveStory')
      end
    end

    [td, script]
  end

  def sprint_backlog_show_story(story)
    url= url_for({:controller=>'sprint_backlog', :action => 'change_state', :id => story.id})
    <<SHOW_STORY
<div id="show_story_#{story.id}" changeAction="#{url}" class="draggable">
#{show_story story}
</div>
<script lang="text/javascript">
new Draggable('show_story_#{story.id}', {revert:true});
</script>
SHOW_STORY
    
  end

  def droppable_div(drop_id, state)
      "<div id='#{drop_id}' state='#{state}'>&nbsp;</div>"
  end

  def script(story_id, drop_id, on_drop_function)
      "Droppables.add('#{drop_id}', {containment:$('show_story_#{story_id}').up('td'), hoverclass:'droppable_hovered', onDrop:#{on_drop_function}});"
  end

end
