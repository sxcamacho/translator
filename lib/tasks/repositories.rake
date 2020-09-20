namespace :repositories do
  desc "Synchronize repositories"
  task synchronize: :environment do
    Rails.logger.info('starting task')
    Commit.connection.truncate(Commit.table_name)
    Git.clone('https://github.com/vuejs/vuejs.org.git', 'vuejs.org', :path => ' /tmp/repositories')
    repository = Git.open('/tmp/repositories/vuejs.org')
    logs = repository.log(1000000).sort_by(:&date)
    logs.each { |log| 
      commit = Commit.create!({
        sha: log.sha,
        parent_sha: log.parent.present? ? log.parent.sha : nil,
        author_name: log.author.name,
        author_email: log.author.email,
        date: log.date,
        message: log.message   
      })
      commit.save!
      Rails.logger.info("#{commit.sha} by #{commit.author_name}<#{commit.author_email}>")
    }
    Rails.logger.info('task completed!')
  end
end