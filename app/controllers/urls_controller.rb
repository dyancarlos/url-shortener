class UrlsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: 'Invalid short url' }
  end

  def show
    @url = ShortUrl.find_by!(short_url_code: params[:url_code])
    Urls::CountAccessService.new(@url).call
    redirect_to @url.original_url, allow_other_host: true
  end

  def create
    @service = Urls::CreateService.new(url_params).call

    if @service.valid?
      render json: { short_url: Urls::BuildShortUrlService.new(@service, request).call }
    else
      render json: { error: 'Invalid URL' }
    end
  end

  private

  def url_params
    params.require(:short_url).permit(:original_url)
  end
end
