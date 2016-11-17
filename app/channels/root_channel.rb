# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class RootChannel < ApplicationCable::Channel
  def follow
    stream_from 'questions'
  end
end
