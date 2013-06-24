module Yinlang

  class ParseError < Citrus::ParseError
    def initialize citrus_error, citrus_match, details = nil, events = []
      #@citrus_error, @match, @details, @events = citrus_error, citrus_match, details, events
      @error   = citrus_error
      @match   = citrus_match
      @details = details
      @events  = events
    end
    attr :error, :match, :details, :events

    def custom_message
      <<-END_OF_MESSAGE
        !!! Yinlang parsing error !!!
        invalid stuff on line #{error.line_number} at offset #{error.line_offset}

        #{error.detail}
        #{ if match.respond_to? :color_debug_dump
            "### Tree Dump ###\n#{match.color_debug_dump}"
          end
        }
        \n
      END_OF_MESSAGE
    end
    alias_method :super_message, :message
    alias_method :message, :custom_message

    def object_info
      if object.is_a?(Class) then
        object.name
      else
        "instance of `#{object.class} < #{object.class.superclass}'"
      end
    end
  end

end
