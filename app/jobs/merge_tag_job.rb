class MergeTagJob
  include Sidekiq::Worker

  sidekiq_options queue: :data_cleanup

  def perform(good_tag_id, bad_tag_id)
    bad_taggings = Tagging.select(:id).where(tag_id: bad_tag_id)
    bad_taggings.find_each(batch_size: 1000) do |bad_tagging|
      MergeTaggingJob.perform_async(good_tag_id, bad_tagging.id)
    end
  end
end
