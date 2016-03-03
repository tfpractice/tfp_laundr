module MachineController
  extend ActiveSupport::Concern

    # module ClassMethods

    # end

    # module InstanceMethods

    # end


  included do
    before_action :set_machine, only: [:show, :edit, :update, :destroy, :claim, :fill, :unclaim, :insert_coins, :start, :remove_clothes]
    before_action :get_load, only: [:fill]
    # before_action :set_type

    load_and_authorize_resource

  end
  def claim
    @machine.claim!(current_user)
    redirect_to @machine, notice: " machine #{@machine.name} is yours"
  end
  def unclaim
    @machine.unclaim!
    redirect_to @machine, notice: " machine #{@machine.name} is available"

  end
  def fill
    puts params[:load]
    load = get_load
    puts load
    @machine.fill!(load)
    redirect_to @machine, notice: " machine #{@machine.name} is unpaid"


  end
  def insert_coins
    @machine.insert_coins!(params[:count])
    redirect_to @machine, notice: " machine #{@machine.name} is ready"

  end
  def start
    @machine.start!
    @machine.end_cycle!
    redirect_to @machine, notice: " machine #{@machine.name} is in_progress and has ended"


  end
  def end_cycle

  end
  def remove_clothes
    @machine.remove_clothes!
    redirect_to @machine, notice: " machine #{@machine.name} is yours"


  end
  private

  def get_load
    @load = Load.find(params[:load])
  end
  # Use callbacks to share common setup or constraints between actions.
  # def set_machine
    # @machine = machine.find(params[:id]).becomes(machine)
    # @machine.becomes(machine)
  # end
  # def set_type
  #     @type = type
  #  end

  #  def type
  #      Animal.races.include?(params[:type]) ? params[:type] : "Animal"
  #  end
  # def method_name
  	
  # end

  #  def type_class
  #      type.constantize
  #  end
  # def subclasses
  #   @subclasses = machine.subclasses
  # end

  # Never trust parameters from the scary internet, only allow the white list through.
  # def machine_params
    # params.require(:machine).permit(:name, :position, :type, :state, :user_id)
  # end
end
