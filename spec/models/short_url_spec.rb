require 'spec_helper'

RSpec.describe ShortUrl, type: :model do
  describe 'Validations' do
    subject { create(:short_url) }

    it { should validate_presence_of(:original_url) }
    it { is_expected.to validate_url_of(:original_url) }

    it { should validate_presence_of(:short_url) }
    it { should validate_uniqueness_of(:short_url) }
    it { is_expected.to validate_url_of(:short_url) }

    it { should validate_presence_of(:secret_key) }
    it { should validate_uniqueness_of(:secret_key) }
  end
end
