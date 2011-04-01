class Admin::EscolaridadesController < ApplicationController
  def index
    @escolaridades = Escolaridade.all
  end

  def show
    @escolaridade = Escolaridade.find(params[:id])
  end

  def new
    @escolaridade = Escolaridade.new
  end

  def edit
    @escolaridade = Escolaridade.find(params[:id])
  end

  def create
    @escolaridade = Escolaridade.new(params[:escolaridade])

    if @escolaridade.save
        redirect_to([:admin, @escolaridade], :notice => 'Escolaridade was successfully created.')
    else
        render :action => "new"
    end
  end

  def update
    @escolaridade = Escolaridade.find(params[:id])

    if @escolaridade.update_attributes(params[:escolaridade])
        redirect_to([:admin, @escolaridade], :notice => 'Escolaridade was successfully updated.')
    else
        render :action => "edit"
    end
  end

  def destroy
    @escolaridade = Escolaridade.find(params[:id])
    @escolaridade.destroy

    redirect_to :action => 'index'
  end
end
