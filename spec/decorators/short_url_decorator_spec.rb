require 'spec_helper'

RSpec.describe ShortUrlDecorator do
  let(:short_url) { build(:short_url) }
  subject { ShortUrlDecorator.new(short_url) }

  describe '#shortened_url' do
    it 'provides the shortened url' do
      expect(subject.shortened_url).to eq "#{ENV['BASE_URI']}/#{short_url.slug}"
    end
  end

  describe 'delegated methods' do
    describe '#slug' do
      it 'calls original slug' do
        expect(subject.slug).to eq short_url.slug
      end
    end
  end
end
