class WashersController < ApplicationController
  before_action :set_washer, only: [:show, :edit, :update, :destroy]
  before_action :subclasses
  load_and_authorize_resource


  # GET /washers
  # GET /washers.json
  def index
    @washers = Washer.all
  end

  # GET /washers/1
  # GET /washers/1.json
  def show
  end

  # GET /washers/new
  def new
    @washer = Washer.new
  end

  # GET /washers/1/edit
  def edit
  end

  # POST /washers
  # POST /washers.json
  def create
    @washer = Washer.new(washer_params)

    respond_to do |format|
      if @washer.save
        format.html { redirect_to @washer, notice: 'Washer was successfully created.' }
        format.json { render :show, status: :created, location: @washer }
      else
        format.html { render :new }
        format.json { render json: @washer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /washers/1
  # PATCH/PUT /washers/1.json
  def update
    respond_to do |format|
      if @washer.update(washer_params)
        format.html { redirect_to @washer, notice: 'Washer was successfully updated.' }
        format.json { render :show, status: :ok, location: @washer }
      else
        format.html { render :edit }
        format.json { render json: @washer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /washers/1
  # DELETE /washers/1.json
  def destroy
    @washer.destroy
    respond_to do |format|
      format.html { redirect_to washers_url, notice: 'Washer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_washer
    @washer = Washer.find(params[:id])
  end
  def subclasses
    @subclasses = Washer.subclasses
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def washer_params
    params.require(:washer).permit(:name, :position, :type, :state, :user_id)
  end
end
