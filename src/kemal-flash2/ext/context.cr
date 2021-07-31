# This code 're-opens' the HTTP::Server::Context class to add flash related
# methods.
class HTTP::Server::Context
  @flash_store : Kemal::Flash2::FlashStore = Kemal::Flash2::FlashStore.new

  def flash
    @flash_store ||= Kemal::Flash2::FlashStore.new
  end

  def flash=(store : Kemal::Flash2::FlashStore)
    @flash_store = store
  end
end
