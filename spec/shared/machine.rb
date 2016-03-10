shared_examples_for("a general machine") do
  context 'Machine Module' do
    it 'includes the Machine Module in its ancestors' do
      expect(machine.class.ancestors).to include(Machine)
    end
    describe "attributes" do
      it 'has a position' do
        expect(machine.position).to be_a_kind_of(Numeric)
      end
      it 'has a name' do
        expect(machine.name).to be_a_kind_of(String)
      end
      describe '#user' do
        it 'responds to :user' do
          expect(machine).to respond_to(:user)
        end
        it 'initializes with a nil user' do
          expect(machine.user).to be nil
        end
      end
      describe '#price' do
        it 'has a price method' do
          expect(machine.methods).to include(:price)
        end
      end
      describe '#capacity' do
        it 'has a capacity method' do
          expect(machine.methods).to include(:capacity)
        end
      end
      describe '#period' do
        it 'has a period method' do
          expect(machine.methods).to include(:period)
        end
        #
      end
      describe '#coins' do
        it 'has a coins attribute' do
          # expect(machine).to respond_to(:coins)
          expect(machine.attributes).to include('coins')
        end
        it 'initializes with 0 coins' do
          expect(machine.coins).to be(0)
        end
      end
      describe '#time_remaining' do
        it 'has a time_remaining method' do
          expect(machine.methods).to include(:time_remaining)
        end
        context 'when not in_progess' do
          it 'returns period' do
            expect(machine.time_remaining).to eq(machine.period)
          end
        end
      end
    end
    # describe "methods" do
    #   describe"#sufficient_coins?" do
    #     it "returns true if the machine coins are greater than or equal to the price of the machine" do

    #       expect(machine.sufficient_coins?).to be(false)
    #     end
    #   end
    # end
  end
end
