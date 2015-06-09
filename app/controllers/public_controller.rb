class PublicController < ApplicationController

	layout 'public'

  def index
  	# intro tekst
    @subjects = Subject.all
  end

  def show
    @subjects = Subject.all
  	@page = Page.where(:permalink => params[:permalink], :visible => true).first
  	if @page.nil?
  		redirect_to(:action => 'index')
  	else
  		# display the page content using show.html.erb
  	end
  end
end
