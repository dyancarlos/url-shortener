class Urls::CountAccessService
  def initialize(resource)
    @short_url = resource
  end

  def call
    @short_url.update(access_count: @short_url.access_count + 1)
  end
end
