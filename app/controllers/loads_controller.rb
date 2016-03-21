class LoadsController < ApplicationController
  before_action :set_load, only: [:show, :edit, :update, :destroy,:insert, :merge, :wash, :remove_from_machine, :dry, :finish]
  before_action :get_machine, only: [:insert]
  load_and_authorize_resource :through => :current_user, except: [:index]

  # GET /loads
  # GET /loads.json
  def index
    @loads = loads.all.decorate
  end

  # GET /loads/1
  # GET /loads/1.json
  def show
  end

  # GET /loads/new
  def new
    @load = loads.new
  end

  # GET /loads/1/edit
  def edit
  end

  # POST /loads
  # POST /loads.json
  def create
    @load = loads.new(load_params)

    respond_to do |format|
      if @load.save
        format.html { redirect_to @load, notice: 'Load was successfully created.' }
        format.json { render :show, status: :created, location: @load }
      else
        format.html { render :new }
        format.json { render json: @load.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /loads/1
  # PATCH/PUT /loads/1.json
  def update
    respond_to do |format|
      if @load.update(load_params)
        format.html { redirect_to @load, notice: 'Load was successfully updated.' }
        format.json { render :show, status: :ok, location: @load }
      else
        format.html { render :edit }
        format.json { render json: @load.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loads/1
  # DELETE /loads/1.json
  def destroy
    @load.destroy
    respond_to do |format|
      format.html { redirect_to loads_url, notice: 'Load was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def merge
    @mLoad = Load.find(params[:mergeLoad])
    @load.merge!(@mLoad)
    redirect_to @load

  end

  # def insert
  #   @machine.claim!(current_user)
  #   @machine.fill!(@load)
  #   redirect_to @machine
  # end
  # def remove_from_machine
  #   @load.machine.remove_clothes!
  #   # @load.remove_from_machine!
  #   redirect_to @load

  # end
  # def wash
  #   @load.machine.start!
  #   redirect_to @load
  # end
  # def dry
  #   @load.machine.start!
  #   redirect_to @load

  # end
  # def wash

  # end
  # def wash

  # end
  private
  # Use callbacks to share common setup or constraints between actions.
  def loads
    current_user ? current_user.loads : Load

  end
  def set_load
    @load = Load.find(params[:id])
  end

  def get_machine
    puts params[:machine]
    puts params[:machine_type]
    puts params[:machine_id]
    if @load.state == "dirty"
      @machine = Washer.find(params[:machine])
    elsif @load.state == "wet"
      @machine = Dryer.find(params[:machine])
    end
    # klass = [Washer, Dryer].detect{|c| params["#{c.name.underscore}_id"]}
    # puts klass

    # klass = params[:machine_type]
    # binding.pry

  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def load_params
    params.require(:load).permit(:weight, :name, :state, :user_id, :machine_id, :machine_type)
  end
end
