class ShowsController < ApplicationController
  before_filter :login_required
  def index
    @shows = Show.all
  end

  def show
    @show = Show.find(params[:id])
  end

  def new
    @show = Show.new
  end

  def create
    @show = Show.new(params[:show])
    if @show.save
      flash[:notice] = "Ukázka vytvořena"
      redirect_to @show
    else
      render :action => 'new'
    end
  end

  def edit
    @show = Show.find(params[:id])
  end

  def update
    @show = Show.find(params[:id])
    if @show.update_attributes(params[:show])
      flash[:notice] = "Ukázka aktualizována"
      redirect_to @show
    else
      render :action => 'edit'
    end
  end

  def destroy
    @show = Show.find(params[:id])
    @show.destroy
    flash[:notice] = "Ukázka smazána"
    redirect_to shows_url
  end
end

