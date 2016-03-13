require 'message_bus'
MessageBus.configure(backend: :redis)
on_worker_boot do
  MessageBus.after_fork
end
