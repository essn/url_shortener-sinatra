require 'spec_helper'

RSpec.describe CreateShortUrl, type: :interactor do
  describe '.call' do
    describe 'with valid parameters' do
      let(:original_url) { 'https://original.url' }

      describe 'slug is passed in' do
        let(:slug) { 'slug' }

        subject(:context) do
          CreateShortUrl.call(original_url: original_url, slug: slug)
        end

        it 'creates ShortUrl with slug' do
          expect(context.short_url.slug).to eq slug
        end

        it 'succeeds' do
          expect(context).to be_a_success
        end
      end

      describe 'slug is not passed in' do
        let(:existing_slug) { 'exists' }
        let(:unique_slug) { 'unique' }

        # Pass existing slug first time to validate it will attempt to create
        # a unique slug
        before do
          create(:short_url, slug: existing_slug)
          call_count = 0

          allow(SecureRandom).to receive(:alphanumeric) do
            if call_count.zero?
              call_count += 1
              existing_slug
            else
              unique_slug
            end
          end
        end

        subject(:context) { CreateShortUrl.call(original_url: original_url) }

        it 'generates a unique slug' do
          expect(context.short_url.slug).to eq unique_slug
        end

        it 'succeeds' do
          expect(context).to be_a_success
        end
      end
    end

    describe 'with invalid parameters' do
      subject(:context) { CreateShortUrl.call }

      it 'fails' do
        expect(context).to_not be_a_success
      end
    end
  end
end
