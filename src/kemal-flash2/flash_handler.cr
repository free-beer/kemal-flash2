module Kemal::Flash2
  SESSION_KEY = "flash"

  # A middleware component that gets added to the Kemal configuration to provide
  # the flash related functionality.
  class FlashHandler < Kemal::Handler
    getter session_key : String

    def initialize(@session_key : String = SESSION_KEY)
      super()
    end

    def call(context)
      load_flash(context)
      call_next(context)
      update_flash(context)
    end

    def load_flash(context)
      context.flash = FlashStore.from(JSON.parse(context.session.string(session_key))) if context.session.string?(session_key)
    end

    def update_flash(context)
      context.session.string(session_key, context.flash.following.to_json)
    end
  end
end
