class ShowsController < ApplicationController
  before_filter :login_required
  before_filter :find_show, :only => [:kick, :show, :edit, :update, :destroy, :archive, :unarchive]
  def index
    @shows = Show.unarchived.all.paginate(:page => params[:page])
  end

  def archived
    @shows = Show.archived.all.paginate(:page => params[:page])
  end

  def join
    @subscription = Subscription.new(:user_id => current_user.id, :show_id => @show.id, :subscribed => params[:subscribed])
    if @subscription.save then
      if @subscription.subscribed then
        flash[:notice] = 'Byli jste přihlášeni na akci. Pokud se budete chtít odhlásit, napište vedoucímu akce'
      else
        flash[:notice] = 'Zaznamenali jsme si, že na akci nemůžete jet. Svoje rozhodnutí můžete kdykoli změnit.'
      end
    else
      flash[:error] = 'Na akci vás nebylo možno přihlásit'
    end
    redirect_to :action => 'show'
  end

  def kick
    @show.users.delete User.find(params[:user_id])
    redirect_to :action => 'show'
  end

  def show
  end

  def new
    @show = Show.new
  end

  def create
    @show = Show.new(params[:show])
    if @show.save
      flash[:notice] = "Akce vytvořena"
      redirect_to @show
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @show.update_attributes(params[:show])
      flash[:notice] = "Akce aktualizována"
      redirect_to @show
    else
      render :action => 'edit'
    end
  end

  def destroy
    @show.destroy
    flash[:notice] = "Akce smazána"
    redirect_to shows_url
  end

  def archive
    @show.archive
    if @show.save then
      flash[:notice] = "Akce archivována"
      redirect_to shows_url
    else
      flash[:error] = "Došlo k neočekávané chybě"
      redirect_to @show
    end
  end

  def unarchive
    @show.unarchive
    if @show.save then
      flash[:notice] = "Akce byla odarchivována"
      redirect_to shows.url
    else
      flash[:error] = "Došlo k neočekávané chybě"
      redirect_to @show
    end
  end

  private
  def find_show
    @show = Show.find(params[:id])
  end
end

