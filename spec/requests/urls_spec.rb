require 'rails_helper'

RSpec.describe "Urls", type: :request do
  describe "POST /create" do
    context 'when valid url format' do
      subject(:create_url) { post urls_path, params: { short_url: { original_url: 'http://google.com' } } }

      it 'generates a short URL' do
        expect do
          subject
        end.to change(ShortUrl, :count).by(1)
      end

      it 'returns the generated short url code' do
        allow(SecureRandom).to receive(:hex).and_return('abc')
        subject
        expect(JSON.parse(body)).to eq({ "short_url" => "www.example.com/abc" })
      end

      it 'generates a shor URL with correct values' do
        allow(SecureRandom).to receive(:hex).and_return('abc')
        subject
        url = ShortUrl.last
        expect(url.original_url).to eq 'http://google.com'
        expect(url.short_url_code).to eq 'abc'
      end
    end

    context 'when invalid url format' do
      subject(:create_url) { post urls_path, params: { short_url: { original_url: 'google.com' } } }

      it 'does not create short url while invalid original url' do
        subject
        expect(JSON.parse(body)).to eq({ "error" => "Invalid URL" })
      end
    end
  end

  describe "GET /show" do
    context 'when valid short url code' do
      let!(:short_url) { FactoryBot.create(:short_url, original_url: 'http://google.com', short_url_code: 'abc') }

      it 'redirects to the original url' do
        get '/abc'
        expect(response).to redirect_to 'http://google.com'
      end

      it 'increases the access count' do
        expect do
          get '/abc'
        end.to change { short_url.reload.access_count }.from(0).to(1)
      end
    end

    context 'when invalid short url code' do
      it 'returns error message' do
        get '/invalid'
        expect(JSON.parse(body)).to eq({ "error" => "Invalid short url" })
      end
    end
  end
end
