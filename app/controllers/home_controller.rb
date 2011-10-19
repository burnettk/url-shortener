class HomeController < InheritedResources::Base

  def about
    @page_title = 'About this site'
  end

end
