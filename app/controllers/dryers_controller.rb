class DryersController < ApplicationController
  include MachineController
  # before_action :set_dryer, only: [:show, :edit, :update, :destroy]

  # GET /dryers
  # GET /dryers.json
  def index
    @dryers = Dryer.all
  end

  # GET /dryers/1
  # GET /dryers/1.json
  def show
  end

  # GET /dryers/new
  def new
    @dryer = Dryer.new
  end

  # GET /dryers/1/edit
  def edit
  end

  # POST /dryers
  # POST /dryers.json
  def create
    @dryer = Dryer.new(dryer_params)

    respond_to do |format|
      if @dryer.save
        format.html { redirect_to @dryer, notice: 'Dryer was successfully created.' }
        format.json { render :show, status: :created, location: @dryer }
      else
        format.html { render :new }
        format.json { render json: @dryer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dryers/1
  # PATCH/PUT /dryers/1.json
  def update
    respond_to do |format|
      if @dryer.update(dryer_params)
        format.html { redirect_to @dryer, notice: 'Dryer was successfully updated.' }
        format.json { render :show, status: :ok, location: @dryer }
      else
        format.html { render :edit }
        format.json { render json: @dryer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dryers/1
  # DELETE /dryers/1.json
  def destroy
    @dryer.destroy
    respond_to do |format|
      format.html { redirect_to dryers_url, notice: 'Dryer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_machine
      @machine = Dryer.find(params[:id])
      @dryer =@machine
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dryer_params
      params.require(:dryer).permit(:name, :position, :state, :user_id)
    end
end
