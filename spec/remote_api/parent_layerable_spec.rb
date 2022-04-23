RSpec.describe RemoteAPI::ParentLayerable do
  let(:layerable_base_class) do
    Class.new do
      include RemoteAPI::ParentLayerable

      comprised_of :some_associated_parts # i.e., plural of "some_associated_part"
    end
  end

  context 'when directly used,' do
    describe 'class interface' do
      it 'includes .comprised_of' do
        expect(layerable_base_class).to respond_to :comprised_of
      end

      it 'includes inferred method for declaring a part to associate in composition' do
        expect(layerable_base_class).to respond_to :some_associated_part
      end
    end

    describe 'instance interface' do
      let(:object) { layerable_base_class.new }

      it 'does not include #comprised_of' do
        expect(object).not_to respond_to :comprised_of
      end

      it 'does not include inferred method for declaring a part to associate in composition' do
        expect(object).not_to respond_to :some_associated_part
      end
    end
  end

  context 'when inherited' do
    let(:klass) do
      Class.new(layerable_base_class) do
        some_associated_part :foo  # assumed class will be FooSomeAssociatedPart
        some_associated_part :bar  # assumed class will be BarsomeAssociatedPart
      end
    end

    before do
      stub_const('FooSomeAssociatedPart', Class.new)
      stub_const('BarSomeAssociatedPart', Class.new)
    end

    describe 'class interface' do
      it 'includes .comprised_of' do
        expect(klass).to respond_to :comprised_of
      end

      it 'includes inferred method for declaring a part to associate in composition' do
        expect(klass).to respond_to :some_associated_part
      end

      it 'does not include inferred method for name of associated part (e.g., :foo)' do
        expect(klass).not_to respond_to :foo
      end

      it 'does not include inferred method for finding all associated parts in composition' do
        expect(klass).not_to respond_to :some_associated_parts
      end
    end

    describe 'instance interface' do
      let(:object) { klass.new }

      it 'does not include #comprised_of' do
        expect(object).not_to respond_to :comprised_of
      end

      it 'does not include inferred method for declaring a part to associate in composition' do
        expect(object).not_to respond_to :some_associated_part
      end

      it 'includes inferred method for name of associated part (e.g., :foo)' do
        expect(object).to respond_to :foo
      end

      it 'includes inferred method for finding all associated parts in composition' do
        expect(object).to respond_to :some_associated_parts
      end
    end

    describe 'instance behavior' do
      let(:object) { klass.new }

      describe 'using inferred method for name of associated part' do
        it '(e.g., #foo) returns expected class' do
          expect(object.foo).to eq FooSomeAssociatedPart
        end

        it '(e.g., #bar) returns expected class' do
          expect(object.bar).to eq BarSomeAssociatedPart
        end
      end

      describe 'using inferred method for finding all associated parts in composition' do
        let(:some_associated_parts) { object.some_associated_parts }

        it 'returns Hash' do
          expect(some_associated_parts).to be_a Hash
        end

        it 'responds to []' do
          expect(some_associated_parts).to respond_to(:[])
        end

        it '[:foo] returns FooSomeAssociatedPart' do
          expect(some_associated_parts[:foo]).to eq FooSomeAssociatedPart
        end

        it '[:bar] returns BarSomeAssociatedPart' do
          expect(some_associated_parts[:bar]).to eq BarSomeAssociatedPart
        end
      end
    end
  end

  context 'when malformed' do
    context 'with bad argument to .comprised_of' do
      let(:bad_base_class) do
        Class.new do
          include RemoteAPI::ParentLayerable

          comprised_of 5 # argument to .comprised_of must be a symbol or a string
        end
      end

      let(:doomed_subclass) do
        Class.new(bad_base_class) do
          some_associated_part :foo # assuming FooSomeAssociatedPart
        end
      end

      it 'directly using the class raises an error' do
        expect { bad_base_class }.to raise_error RemoteAPI::RemoteAPIConfigurationError
      end

      it 'inheriting from the class raises an error' do
        expect { doomed_subclass }.to raise_error RemoteAPI::RemoteAPIConfigurationError
      end
    end

    describe 'directly using inherited class' do
      context 'when it has an invalid argument' do
        let(:bad_subclass) do
          Class.new(layerable_base_class) do
            some_associated_part 5 # argument here must be a symbol or a string
          end
        end

        it 'raises an error' do
          expect { bad_subclass }.to raise_error RemoteAPI::RemoteAPIConfigurationError
        end
      end

      context 'when associated part is not a class' do
        let(:bad_subclass) do
          Class.new(layerable_base_class) do
            some_associated_part :not_a_class # assuming NotAClassSomeAssociatedPart
          end
        end

        before do
          stub_const('NotAClassSomeAssociatedPart', 5)
        end

        it 'raises an error' do
          expect { bad_subclass }.to raise_error RemoteAPI::RemoteAPIConfigurationError
        end
      end

      context 'when missing associated part class to compose' do
        let(:incomplete_subclass) do
          Class.new(layerable_base_class) do
            some_associated_part :doesnt_exist # assuming DoesntExistSomeAssociatedPart
          end
        end

        it 'raises an error' do
          expect { incomplete_subclass }.to raise_error RemoteAPI::RemoteAPIConfigurationError
        end
      end
    end
  end
end
