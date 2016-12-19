require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  it 'matches with enqueued job' do
    ActiveJob::Base.queue_adapter = :test
    expect do
      NewAnswerNotificationJob.perform_later
    end.to enqueue_job(NewAnswerNotificationJob)
  end
end
