require "rubygems"
require "bundler"

Bundler.require

require "dotenv/load"
require "uri"

desc "Loads all files from FTP and dumps the DP"
task :backup do
  ftp.pull_dir "backup", "/" + @path, since: true, skip_errors: true
  dump_db
  commit
end

def ftp
  @ftp ||= begin
    url = URI(ENV["FTP"])
    user, password, host, @path = [:user, :password, :host, :path].map { |e| url.send(e) }
    ftp = FtpSync.new host, user, password
  end
end

def sh(command)
  error "could not execute '#{command}'" unless system(command)
end

def dump_db
  uri = URI.parse ENV["DATABASE_URL"]
  db_name = uri.path.sub("/", "").freeze
  args = [
    "mysqldump",
    "--databases", db_name,
    "--quote-names",
    "--result-file", "backup/data.sql",
    "--host", uri.host,
    "-p#{uri.password}",
    "--user", uri.user,
    "--lock-tables=false"
  ]
  sh args.join(" ")
end

def commit
  sh "cd backup && git init && git add . && git commit -m 'backup at #{Time.now}' --allow-empty"
end
