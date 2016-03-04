class WashersController < ApplicationController
  include MachineController
  # before_action :set_washer, only: [:show, :edit, :update, :destroy, :claim, :fill, :unclaim, :insert_coins, :start, :remove_clothes]
  before_action :subclasses
  # before_action :set_type
  # attr_accessor :coins

  load_and_authorize_resource


  # GET /washers
  # GET /washers.json
  def index
    # @washers = WasherDecorator.decorate_collection(Washer.all, with: WasherDecorator)
    @washers = Washer.all.decorate
    # @washers.becomes(Washer)
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
  def claim
    @washer.claim!(current_user)
    redirect_to @washer, notice: " Washer #{@washer.name} is yours"
  end
  # def unclaim
  #   @washer.unclaim!
  #   redirect_to @washer, notice: " Washer #{@washer.name} is available"

  # end
  # def fill
  #   @washer.fill!
  #   redirect_to @washer, notice: " Washer #{@washer.name} is unpaid"


  # end
  # def insert_coins(coins=0)
  #   @washer.insert_coins!
  #   redirect_to @washer, notice: " Washer #{@washer.name} is ready"

  # end
  # def start
  #   @washer.start!
  #   @washer.end_cycle!
  #   redirect_to @washer, notice: " Washer #{@washer.name} is in_progress and has ended"


  # end
  # def end_cycle

  # end
  # def remove_clothes
  #   @washer.remove_clothes!
  #   redirect_to @washer, notice: " Washer #{@washer.name} is yours"


  # end


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
  def set_machine
    @machine = WasherDecorator.find(params[:id])
    @washer = @machine

    # @washer = Washer.find(params[:id]).becomes(Washer)
    # @washer.becomes(Washer)
  end
  # def set_type
  #     @type = type
  #  end

  #  def type
  #      Animal.races.include?(params[:type]) ? params[:type] : "Animal"
  #  end

  #  def type_class
  #      type.constantize
  #  end
  def subclasses
    @subclasses = Washer.subclasses
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def washer_params
    params.require(:washer).permit(:name, :position, :type, :state, :user_id, :count, :load_id)
  end
end
