shared_examples_for("a specific machine") do


  describe "methods" do
    describe"#enough_coins?" do
      it "returns false if the machine coins are less than or equal to the price of the machine" do
        expect(machine.enough_coins?).to be(false)
      end
      it "return true of the coins are greater of equal to the price" do
        machine.coins = sufficient_coins
        expect(machine.enough_coins?).to be(true)

      end
    end

    describe '#reset_coins' do
      it 'resets @coins to 0' do
        machine.coins = 2
        expect{machine.reset_coins}.to change{machine.coins}.from(2).to(0)
      end
    end
    # describe '#coin_excess?' do
      # it 'checks if quantity coins inserted exceeds price ' do
        # expect(washer).to respond_to(:coin_excess?)

      # end
      # context 'when inserting insufficient coins' do
        # it 'returns false' do
          # washer.claim!(user)
          # puts "slef.capacity #{washer.capacity}"
          # washer.fill!(load)
          # washer.insert_coins!(5)
          # expect(washer.coin_excess?).to be(false)
        # end

      # end

    # end
  end


  context 'statemachine' do
    #   let(:machine) { create(:m_machine) }
    it 'initializes with :available as default state' do
      expect(machine.state).to eq("available")
    end
    describe '#next_steps' do
      it 'returns the keys of the next possible event for the current state' do
        expect(machine.next_steps).to include("claim")
      end
    end
    describe '#claim' do
      it 'responds to #claim ' do
        expect(machine).to respond_to(:claim)
      end
      it 'changes machine user id to current_user' do
        expect{machine.claim!(user)}.to change{machine.user}.from(nil).to(user)
      end
      it 'changes machine state to :empty' do
        machine.claim!(user)
        expect(machine.state).to eq("empty")
      end
    end
    context 'when empty' do
      before(:each) do
        machine.claim!(user)
      end
      describe '#unclaim' do
        it 'responds to #unclaim ' do
          expect(machine).to respond_to(:unclaim)
        end
        it 'changes machine state to :empty' do
          machine.unclaim!
          expect(machine.state).to eq("available")
        end
        it 'changes machine user id to nil' do
          expect{machine.unclaim!}.to change{machine.user}.from(user).to(nil)
        end
      end
      describe '#fill' do
        it 'responds to #fill ' do
          expect(machine).to respond_to(:fill)
        end

        context 'when nil load' do
          it 'changes raises "null weight Error" ' do
            expect { machine.fill! }.to raise_error("Cannot insert an empty load")
          end
        end
        context 'when load too large ' do
          it 'changes raises "Load Weight Error" ' do
            # bigLoad = create(:load, user: user, weight: 50)
            expect { machine.fill!(bigLoad) }.to raise_error("Cannot insert a load heavier than capacity")
          end
        end
        context 'when load will fit ' do
          it 'changes machine state to :unpaid' do
            expect{machine.fill!(load)}.to change{machine.state}.from("empty").to("unpaid")
          end
          it 'reduces machine capacity' do
            expect{machine.fill!(load)}.to change{machine.capacity}.by(-(load.weight))
          end
          it 'assigns machine load' do
            expect{machine.fill!(load)}.to change{machine.load}.from(nil).to(load)
          end
        end
      end
      context 'when unpaid' do
        before(:each) do
          machine.fill!(load)
        end


        describe '#insert_coins' do
          it 'responds to #insert_coins ' do
            expect(machine).to respond_to(:insert_coins)
          end
          context 'when no coins inserted' do

            it 'changes coins by 0 without args' do
              expect{machine.insert_coins!}.not_to change{machine.coins}
            end
          end
          context 'when insufficient coins inserted' do

            it 'raises an exception' do
              puts "pre halt #{machine.coins}"
              machine.insert_coins(insufficient_coins)
              puts "post halt #{machine.coins}"

              expect{machine.insert_coins!(insufficient_coins)}.to change{machine.coins}.by(insufficient_coins)
            end
            it 'does not change machine state' do
              expect{machine.insert_coins!(insufficient_coins)}.not_to change{machine.state}
            end
          end
          it 'persists the coin change' do
            puts " pre-insert machine.coins #{machine.coins}"

            machine.insert_coins!(insufficient_coins)
            puts " pre-reload machine.coins #{machine.coins}"
            machine.reload
            puts "post-insert machine.coins #{machine.coins}"
            expect(machine.coins).to eq(insufficient_coins)
          end
          xit 'changes price by count' do
            puts machine.price
            expect{machine.insert_coins!(sufficient_coins)}.to change{machine.price}.by(sufficient_coins)
          end
          it 'changes machine state to ready' do
            expect{machine.insert_coins!(sufficient_coins)}.to change{machine.state}.from("unpaid").to("ready")
          end
        end
        context 'when ready' do
          before(:each) do
            machine.insert_coins!(sufficient_coins)
          end
          describe '#start' do
            it 'responds to #start ' do
              expect(machine).to respond_to(:start)
            end
            it 'changes machine state to :in_progess' do
              expect{machine.start!}.to change{machine.state}.from("ready").to("in_progess")
            end
            it 'changes @end_time' do
              machine.start!
              expect(machine.end_time).not_to be_nil
              # expect{machine.start!}.to change{machine.end_time}.from(nil).to((Time.now + machine.period))
            end
          end
          context 'when in_progess' do
            before(:each) do
              machine.start!
            end
            describe '#end_cycle' do
              it 'responds to #end_cycle ' do
                expect(machine).to respond_to(:end_cycle)
              end

              it 'changes machine state to :in_progess' do
                expect{machine.end_cycle!}.to change{machine.state}.from("in_progess").to("complete")
              end
            end
            context 'when complete' do
              before(:each) do
                machine.end_cycle!
              end
              describe '#remove_clothes' do
                it 'responds to #remove_clothes ' do
                  expect(machine).to respond_to(:remove_clothes)
                end
                it 'changes machine state to :empty' do
                  expect{machine.remove_clothes!}.to change{machine.state}.from("complete").to("empty")
                end
              end
            end

          end
        end
      end
    end
  end
end
