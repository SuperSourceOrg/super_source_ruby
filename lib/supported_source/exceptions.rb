module SuperSource
  class InvalidProjectToken < StandardError; end
  class MissingProjectToken < StandardError; end
  class MissingProjectRoot < StandardError; end

  module Exceptions
    def Exceptions.help_message
      "\n\n * " + ["To get client tokens, run `supso update`.",
        "If you do not have the supso command line interface yet, first run `gem install supso`.",
        "Visit http://supso.org/help for further help.",
      ].join("\n\n * ") + "\n\n"
    end
  end
end
