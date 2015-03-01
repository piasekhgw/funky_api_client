class Bar < FunkyApiClient::Base
  class_call :count, 'bar/:bar_id/count', true
  attribute :id
end

class Foo < FunkyApiClient::Base
  class_call :fetch, 'foo/fetch'
  instance_call :save, 'foo/:id', :post, :data_to_save

  attribute :id
  attribute :name
  attribute :bars, Array[Bar]

  def data_to_save
    { name: name }.to_json
  end
end

describe FunkyApiClient::Base do
  let(:backend_url) { 'http://test.com' }
  before do
    allow(FunkyApiClient).to receive(:backend_url).and_return(backend_url)
  end
  let(:count_url) { "#{backend_url}/bar/1/count" }
  let(:fetch_url) { "#{backend_url}/foo/fetch" }
  let(:save_url) { "#{backend_url}/foo/1" }

  describe 'class call' do
    describe 'parameters passing' do
      before do
        allow(FunkyApiClient::HttpRequest).to receive(:perform)
        allow(Bar).to receive(:handle_class_call_response)
      end
      it 'passes proper params to HttpRequest class perform method' do
        expect(FunkyApiClient::HttpRequest).to receive(:perform).with(
          :get,
          'bar/1/count',
          query: { 'test' => 1 },
          headers: { test_header: 'test_value' }
        )
        Bar.count(params: { bar_id: 1, test: 1 }, headers: { test_header: 'test_value' })
      end
    end

    describe 'request handling' do
      context 'when successful response' do
        context 'when :plain_response option is set' do
          before { stub_request(:get, count_url).to_return(body: '123', status: 200) }
          it 'returns value from server response' do
            expect(Bar.count(params: { bar_id: 1 })).to eq('123')
          end
        end

        context 'when :plain_response option is not set' do
          context 'when response is not json' do
            before { stub_request(:get, fetch_url).to_return(body: 'not json', status: 200) }
            it 'raises generic error' do
              expect { Foo.fetch }.to raise_error(FunkyApiClient::Errors::GenericError)
            end
          end

          context 'when response is array of hashes' do
            let(:response_body) do
              [
                { id: 1, name: 'n1', bars: [{ id: 1 }, { id: 2 }] },
                { id: 2, name: 'n2', bars: [{ id: 3 }] }
              ]
            end
            before { stub_request(:get, fetch_url).to_return(body: response_body.to_json, status: 200) }
            it 'maps response to array of objects' do
              mapped_response = Foo.fetch
              expect(mapped_response.map(&:class)).to eq([Foo, Foo])
              expect(mapped_response.first.bars.map(&:class)).to eq([Bar, Bar])
              expect(mapped_response.last.bars.map(&:class)).to eq([Bar])
              expect(mapped_response.first).to have_attributes(id: 1, name: 'n1')
              expect(mapped_response.last).to have_attributes(id: 2, name: 'n2')
              expect(mapped_response.first.bars.first).to have_attributes(id: 1)
              expect(mapped_response.first.bars.last).to have_attributes(id: 2)
              expect(mapped_response.last.bars.first).to have_attributes(id: 3)
            end
          end

          context 'when response is a hash' do
            let(:response_body) { { id: 1, name: 'n1', bars: [{ id: 1 }] } }
            before { stub_request(:get, fetch_url).to_return(body: response_body.to_json, status: 200) }
            it 'maps response to proper object' do
              mapped_response = Foo.fetch
              expect(mapped_response.class).to eq(Foo)
              expect(mapped_response.bars.map(&:class)).to eq([Bar])
              expect(mapped_response).to have_attributes(id: 1, name: 'n1')
              expect(mapped_response.bars.first).to have_attributes(id: 1)
            end
          end
        end
      end

      context 'when unsuccessful response' do
        context 'when response status is 404' do
          before { stub_request(:get, fetch_url).to_return(status: 404) }
          it 'raises record_not_found error' do
            expect { Foo.fetch }.to raise_error(FunkyApiClient::Errors::RecordNotFoundError)
          end
        end

        context 'when response status is other than 404' do
          before { stub_request(:get, fetch_url).to_return(status: 500) }
          it 'raises generic error' do
            expect { Foo.fetch }.to raise_error(FunkyApiClient::Errors::GenericError)
          end
        end
      end
    end
  end

  describe 'instance call' do
    let(:request_body) { { name: 'n1' } }
    let(:foo) { Foo.new(id: 1, name: 'n1') }

    describe 'parameters passing' do
      before do
        allow(FunkyApiClient::HttpRequest).to receive(:perform)
        allow(foo).to receive(:handle_instance_call_response)
      end
      it 'passes proper params to HttpRequest class perform method' do
        expect(FunkyApiClient::HttpRequest).to receive(:perform).with(
          :post,
          'foo/1',
          query: { 'test' => 1 },
          body: request_body.to_json,
          headers: { test_header: 'test_value' }
        )
        foo.save(params: { id: foo.id, test: 1 }, headers: { test_header: 'test_value' })
      end
    end

    describe 'request handling' do
      context 'when successful response' do
        before { stub_request(:post, save_url).with(body: request_body.to_json).to_return(status: 200) }
        it 'returns true' do
          expect(foo.save(params: { id: foo.id })).to eq(true)
        end
        it 'has no response_errors (valid? method returns true)' do
          foo.save(params: { id: foo.id })
          expect(foo.response_errors).to eq([])
          expect(foo.valid?).to eq(true)
        end
      end

      context 'when unsuccessful response' do
        context 'when response status is 422' do
          before do
            stub_request(:post, save_url).with(body: request_body.to_json).to_return(
              body: { errors: ['error_message1', 'error_message2'] }.to_json,
              status: 422
            )
          end
          it 'returns false' do
            expect(foo.save(params: { id: foo.id })).to eq(false)
          end
          it 'sets response_errors (valid? method returns false)' do
            foo.save(params: { id: foo.id })
            expect(foo.response_errors).to eq(['error_message1', 'error_message2'])
            expect(foo.valid?).to eq(false)
          end
        end

        context 'when response status is other than 422' do
          before { stub_request(:post, save_url).with(body: request_body.to_json).to_return(status: 500) }
          it 'raises generic error' do
            expect { foo.save(params: { id: foo.id }) }.to raise_error(FunkyApiClient::Errors::GenericError)
          end
        end
      end
    end
  end
end
