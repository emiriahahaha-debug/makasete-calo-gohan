require 'rails_helper'

RSpec.describe "CanonicalHostRedirect", type: :request do
  let(:onrender_host) { "makasete-calo-gohan.onrender.com" }
  let(:canonical_host) { "makasete-calo-gohan.toma15.com" }

  describe "onrender.comへのアクセス" do
    before { host! onrender_host }

    it "独自ドメインへ301リダイレクトされる" do
      get root_path

      expect(response).to have_http_status(:moved_permanently)
      expect(response.headers["Location"]).to eq("https://#{canonical_host}/")
    end

    it "パスを保持したままリダイレクトされる" do
      get how_to_use_path

      expect(response.headers["Location"]).to eq("https://#{canonical_host}/how_to_use")
    end

    it "クエリパラメータを保持したままリダイレクトされる" do
      get how_to_use_path, params: { step: 2 }

      expect(response.headers["Location"]).to eq("https://#{canonical_host}/how_to_use?step=2")
    end

    it "ヘルスチェック(/up)はリダイレクトされない" do
      get rails_health_check_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "独自ドメインへのアクセス" do
    before { host! canonical_host }

    it "リダイレクトされない" do
      get root_path

      expect(response).to have_http_status(:ok)
    end
  end
end
