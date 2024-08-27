class Urls::BuildShortUrlService
  def initialize(resource, request)
    @resource = resource
    @request = request
  end

  def call
    "#{@request.host}/#{@resource.short_url_code}"
  end
end
