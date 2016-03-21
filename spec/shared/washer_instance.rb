shared_examples_for("a washer instance") do

  describe '#coin_excess?' do
    before(:each) do
      washer.claim!(user)

      washer.fill!(load)
    end
    it 'checks if quantity coins inserted will exceeds price ' do
      expect(washer).to respond_to(:coin_excess?)
    end
    context 'when inserting insufficient coins' do
      it 'returns false' do
        expect(washer.coin_excess?(insufficient_coins)).to be(false)
      end
    end
    context 'when inserting excessive coins' do
      it 'retuns true' do
        expect(washer.coin_excess?(excessive_coins)).to be(true)
      end
    end
  end

  context 'when washer has coins ' do
    before(:each) do
      washer.claim!(user)
      # washer.coins = insufficient_coins
      # washer.fill!(load)
      # washer.insert_coins!(sufficient_coins)
      # washer.start!
      # washer.end_cycle!
    end
    context ' insufficient coins ' do
      it 'changes washer state to "unpaid"  ' do
        washer.coins= insufficient_coins
        expect{washer.fill!(load)}.to change{washer.state}.from("empty").to("unpaid")
      end
    end
    context 'enough coins ' do
      it 'changes washer status to "ready" ' do
        washer.coins = washer.price
        # bigLoad = create(:load, user: user, weight: 50)
        expect{washer.fill!(load)}.to change{washer.state}.from("empty").to("ready")
      end

    end
    describe '#fill' do
      it 'sets the loads sate to in_washer' do
        washer.fill!(load)
        expect(load.state).to eq("in_washer")
      end
    end
    describe '#return_coins' do
      before(:each) do
        washer.coins = insufficient_coins
      end
      it 'sets @coins to zero' do
        expect{washer.return_coins!}.to change{washer.coins}.from(insufficient_coins).to(0)
      end
      it 'does not change state' do
        expect{washer.return_coins!}.not_to change{washer.state}.from("empty")
      end
    end
    context 'when unpaid' do
      before(:each) do
        washer.fill!(load)
      end
      context 'when too many coins inserted' do
        it 'adds a Worflow TransitionHalted error to washer.errors' do
          washer.insert_coins!(excessive_coins)
          expect(washer.errors).to include(:coins)
        end
        it 'does not change  washer state' do
          expect{washer.insert_coins!(excessive_coins)}.not_to change{washer.state}.from("unpaid")
        end
      end
      context 'when ready' do
        before(:each) do
          washer.insert_coins!(washer.price)
          # washer.start!
        end
        describe '#start' do
          it 'changes load state to washed' do
            washer.start!
            expect(washer.load.state).to eq("washed")
          end

        end
      end
    end
  end




end
