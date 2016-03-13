class WashersController < ApplicationController
  include MachineController
  before_action :subclasses
  before_action :coin_excess, only: [:insert_coins]

  # rescue_from Workflow::TransitionHalted, with: :model_coin_excess


  load_and_authorize_resource


  # GET /washers
  # GET /washers.json
  def index
    # @washers = WasherDecorator.decorate_collection(Washer.all)
    # @washers = WashersDecorator.new(Washer.all)
    @washers = WasherDecorator.all
    if current_user
      @my_washers = current_user.washers.order(state: :asc).decorate
      @available_washers = @washers.with_available_state.decorate - @my_washers
    else
      @available_washers = @washers.available_machines.decorate
    end
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


  end
  def coin_excess
    submitted_coins = params[:count].to_i
    if @machine.coins + submitted_coins > @machine.price
      newCoins = @machine.coins + submitted_coins
      coin_diff = @machine.price - @machine.coins
      flash[:error] = "machine currently has #{@machine.coins}, cannot insert more than #{coin_diff} coins "
      redirect_to @machine, notice: " Please insert #{coin_diff} coins "
    end
  end

  def subclasses
    @subclasses = Washer.subclasses
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def washer_params
    params.require(:washer).permit(:name, :position, :type, :state, :user_id, :count, :load_id)
  end
end
