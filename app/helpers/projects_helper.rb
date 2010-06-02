module ProjectsHelper
  def pigs(disabled=false)
    render :partial => 'pigs', :locals => {:disabled => disabled}
  end
  def chickens(disabled=false)
    render :partial => 'chickens', :locals => {:disabled => disabled}
  end
end
