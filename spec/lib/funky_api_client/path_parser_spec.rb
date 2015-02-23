describe FunkyApiClient::PathParser do
  describe '#call' do
    let(:path_parser) { described_class.new('/foo/:id/bar/:test_id/baz') }

    context 'when passed params are correct' do
      context 'only ruote params passed' do
        it 'returns proper path' do
          expect(path_parser.call(id: 1, 'test_id' => '2')).to eq('/foo/1/bar/2/baz')
        end
      end

      context 'more (than needed) params passed' do
        it 'returns proper path' do
          expect(path_parser.call(id: 1, test_id: 2, other_attr: 3)).to eq('/foo/1/bar/2/baz')
        end
      end
    end

    context 'when passed params are invalid' do
      context 'when no route params passed' do
        it 'raises invalid params exception' do
          expect { path_parser.call(other_attr: 123) }.to(
            raise_error(FunkyApiClient::Errors::InvalidParamsError)
          )
        end
      end

      context 'when not all ruote params passed' do
        it 'raises invalid params exception' do
          expect { path_parser.call(other_attr: 123, id: 123) }.to(
            raise_error(FunkyApiClient::Errors::InvalidParamsError)
          )
        end
      end
    end
  end
end
