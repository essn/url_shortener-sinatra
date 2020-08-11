require 'spec_helper'

RSpec.describe 'Short Url Requests' do
  describe 'POST /short_url' do
    let(:slug) { 'slug' }
    let(:original_url) { 'original_url' }

    describe 'success' do
      let(:short_url) { build(:short_url) }

      before do
        allow(CreateShortUrl).to receive(:call)
          .with(slug: slug, original_url: original_url)
          .and_return(double(:result, success?: true, short_url: short_url))

        post '/short_url', slug: slug, original_url: original_url
      end

      it 'returns shortened url' do
        shortened_url = JSON.parse(last_response.body)
                            .dig('body', 'short_url', 'shortened_url')

        expect(shortened_url)
          .to eq ShortUrlDecorator.new(short_url).shortened_url
      end

      it 'returns secret key' do
        key = JSON.parse(last_response.body)
                  .dig('body', 'short_url', 'secret_key')

        expect(key).to eq short_url.secret_key
      end

      it 'returns status 200' do
        expect(last_response.status).to eq 200
      end
    end

    describe 'error' do
      let(:message) { 'dang' }
      let(:short_url) do
        errors_double = double(:errors, full_messages: message)
        double(:short_url, errors: errors_double)
      end

      before do
        allow(CreateShortUrl).to receive(:call)
          .with(slug: slug, original_url: original_url)
          .and_return(double(:result, success?: false, short_url: short_url))

        post '/short_url', slug: slug, original_url: original_url
      end

      it 'returns errors' do
        error_message = JSON.parse(last_response.body).dig('body', 'message')

        expect(error_message).to eq message
      end

      it 'returns status 422' do
        expect(last_response.status).to eq 422
      end
    end
  end

  describe 'DELETE /short_url/:slug' do
    describe 'success' do
      let(:short_url) { create(:short_url) }

      before do
        delete "/short_url/#{short_url.slug}", secret_key: short_url.secret_key
      end

      it 'deletes short url' do
        expect(ShortUrl.find_by(slug: short_url.slug)).to be nil
      end

      it 'returns status 204' do
        expect(last_response.status).to eq 204
      end
    end

    describe 'error' do
      describe 'secret_key parameter is not provided' do
        before { delete '/short_url/slug' }

        it 'returns status 422' do
          expect(last_response.status).to eq 422
        end
      end

      describe 'short url does not exist' do
        before { delete '/short_url/slug', secret_key: 'sshh' }

        it 'returns status 404' do
          expect(last_response.status).to eq 404
        end
      end

      describe 'short url slug does not match secret key' do
        let(:short_url) { create(:short_url) }

        before { delete "/short_url/#{short_url.slug}", secret_key: 'nope' }

        it 'returns status 402' do
          expect(last_response.status).to eq 402
        end
      end
    end
  end
end
