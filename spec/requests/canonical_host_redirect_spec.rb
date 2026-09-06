require 'rails_helper'

RSpec.describe "CanonicalHostRedirect", type: :request do
  before { https! }

  describe "onrender.comへのアクセス" do
    before { host! "makasete-calo-gohan.onrender.com" }

    it "独自ドメインへ301リダイレクトされる" do
      get root_path

      expect(response).to have_http_status(:moved_permanently)
      expect(response.headers["Location"]).to eq("https://makasete-calo-gohan.toma15.com/")
    end

    it "パスを保持したままリダイレクトされる" do
      get how_to_use_path

      expect(response.headers["Location"]).to eq("https://makasete-calo-gohan.toma15.com/how_to_use")
    end

    it "ヘルスチェック(/up)はリダイレクトされない" do
      get rails_health_check_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "独自ドメインへのアクセス" do
    before { host! "makasete-calo-gohan.toma15.com" }

    it "リダイレクトされない" do
      get root_path

      expect(response).to have_http_status(:ok)
    end
  end
end
