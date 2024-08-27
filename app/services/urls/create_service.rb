class Urls::CreateService
  def initialize(params)
    @params = params
  end

  def call
    ShortUrl.create(
      original_url: @params[:original_url],
      short_url_code: short_url_code
    )
  end

  private

  def short_url_code
    SecureRandom.hex(2)
  end
end
