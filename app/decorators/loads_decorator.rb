class LoadsDecorator < Draper::CollectionDecorator

delegate :with_dirty_state , :with_in_washer_state , :with_ashed_state , :with_wet_state , :with_in_dryer_state , :with_dried_state , :with_folded_state , :with_clean_state, :can_fit_machine 

end